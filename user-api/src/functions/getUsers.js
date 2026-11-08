const { app } = require("@azure/functions");
const userService = require("../services/userService");
const { closePool } = require("../config/db");

app.http("getUsers", {
  methods: ["GET"],
  authLevel: "anonymous",
  handler: async (request, context) => {
    context.log(`Http function processed request for url "${request.url}"`);

    try {
      const id = request.query.get("id");
      const email = request.query.get("email");

      const data = id || email;
      const key = id ? "id" : "email";

      context.log(`Query parameters - key: ${key}, data: ${data}`);

      if (data) {
        const user = await userService.getUserByIdOrEmail(key, data);

        if (!user) {
          return {
            status: 404,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ error: "User not found" }),
          };
        }
        return {
          status: 200,
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(user),
        };
      }

      const users = await userService.getAllUsers();
      return {
        status: 200,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(users),
      };
    } catch (error) {
      context.error(`Error processing request: ${error.message}`);
      return {
        status: 500,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ error: "Internal server error" }),
      };
    } finally {
      closePool();
    }
  },
});

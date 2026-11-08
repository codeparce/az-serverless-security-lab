const { app } = require("@azure/functions");
const userService = require("../services/userService");

app.http("addUser", {
  methods: ["POST"],
  authLevel: "anonymous",
  handler: async (request, context) => {
    context.log(`Http function processed request for url "${request.url}"`);
    try {
      const body = await request.json();

      if (!body.name || !body.email || !body.password_hash) {
        return {
          status: 400,
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            error: 'Fields "name", "email", and "password_hash" are required',
          }),
        };
      }

      context.log(`Attempting to register user: ${body.name} (${body.email})`);
      const existing = await userService.getUserByIdOrEmail(
        "email",
        body.email,
      );

      if (existing) {
        return {
          status: 409,
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ error: "Email already registered" }),
        };
      }

      const user = await userService.createUser({
        name: body.name,
        email: body.email,
        password_hash: body.password_hash,
      });
      context.log(`User registered: ${user.name} (ID: ${user.id})`);

      return {
        status: 200,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          message: "User registered successfully",
          user,
        }),
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

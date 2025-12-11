const express = require("express");
const todos = require("./routes/todos");
const client = require("prom-client");

const app = express();

client.collectDefaultMetrics();

app.use(express.json());

app.get("/healthz", (req, res) => {
  res.json({ status: "ok", commit: process.env.GIT_SHA || "dev" });
});

app.use("/api/v1/todos", todos);

app.listen(3000, () => {
  console.log("Server running on port 3000");
});

module.exports = app;

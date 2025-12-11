const request = require("supertest");
const app = require("../src/index");

describe("API Tests", () => {
  test("Health check works", async () => {
    const res = await request(app).get("/healthz");
    expect(res.body.status).toBe("ok");
  });

  test("Create and list todos", async () => {
    await request(app).post("/api/v1/todos").send({ title: "first todo" });
    const res = await request(app).get("/api/v1/todos");
    expect(res.body.length).toBeGreaterThan(0);
  });

  test("Validation failure", async () => {
    const res = await request(app).post("/api/v1/todos").send({});
    expect(res.status).toBe(400);
  });
});

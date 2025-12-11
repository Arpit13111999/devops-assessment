const express = require("express");
const router = express.Router();
const db = require("../db/memory");

router.get("/", (req, res) => {
  res.json(db.list());
});

router.post("/", (req, res) => {
  const { title } = req.body;

  if (!title) {
    return res.status(400).json({ error: "Title is required" });
  }

  const todo = db.create(title);
  res.status(201).json(todo);
});

module.exports = router;

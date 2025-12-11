let todos = [];

function list() {
  return todos;
}

function create(title) {
  const todo = { id: Date.now().toString(), title, done: false };
  todos.push(todo);
  return todo;
}

module.exports = {
  list,
  create
};

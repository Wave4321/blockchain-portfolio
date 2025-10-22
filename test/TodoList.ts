import { expect } from "chai";
import { network } from "hardhat";

const { ethers } = await network.connect();

describe("TodoList", function () {
  let todoList: any;
  let owner: any;
  let alice: any;
  let bob: any;

  beforeEach(async function () {
    [owner, alice, bob] = await ethers.getSigners();
    
    const TodoListFactory = await ethers.getContractFactory("TodoList");
    todoList = await TodoListFactory.deploy();
  });

  describe("addTodo", function () {
    it("Should add a todo correctly", async function () {
      await todoList.addTodo("Study Solidity", "Learn arrays and structs");
      
      expect(await todoList.getTodoCount()).to.equal(1);
      
      const todo = await todoList.getTodo(0);
      expect(todo.id).to.equal(0);
      expect(todo.title).to.equal("Study Solidity");
      expect(todo.content).to.equal("Learn arrays and structs");
      expect(todo.isCompleted).to.equal(false);
    });

    it("Should add multiple todos", async function () {
      await todoList.addTodo("Task 1", "Content 1");
      await todoList.addTodo("Task 2", "Content 2");
      await todoList.addTodo("Task 3", "Content 3");
      
      expect(await todoList.getTodoCount()).to.equal(3);
      
      const todo = await todoList.getTodo(1);
      expect(todo.title).to.equal("Task 2");
    });

    it("Should emit TodoAdded event", async function () {
      await expect(todoList.addTodo("New Task", "Content"))
        .to.emit(todoList, "TodoAdded")
        .withArgs(0, "New Task");
    });
  });

  describe("completeTodo", function () {
    beforeEach(async function () {
      await todoList.addTodo("Finish homework", "Math problems");
    });

    it("Should complete a todo", async function () {
      let todo = await todoList.getTodo(0);
      expect(todo.isCompleted).to.equal(false);
      
      await todoList.completeTodo(0);
      
      todo = await todoList.getTodo(0);
      expect(todo.isCompleted).to.equal(true);
    });

    it("Should emit TodoCompleted event", async function () {
      await expect(todoList.completeTodo(0))
        .to.emit(todoList, "TodoCompleted")
        .withArgs(0);
    });

    it("Should revert if trying to complete twice", async function () {
      await todoList.completeTodo(0);
      
      await expect(todoList.completeTodo(0))
        .to.be.revertedWith("Already completed");
    });
  });

  describe("Error handling", function () {
    it("Should revert on invalid todo ID for getTodo", async function () {
      await expect(todoList.getTodo(0))
        .to.be.revertedWith("Invalid todo ID");
      
      await todoList.addTodo("Task", "Content");
      
      await expect(todoList.getTodo(1))
        .to.be.revertedWith("Invalid todo ID");
    });

    it("Should revert on invalid todo ID for completeTodo", async function () {
      await expect(todoList.completeTodo(0))
        .to.be.revertedWith("Invalid todo ID");
    });
  });

  describe("getActiveTodos", function () {
    beforeEach(async function () {
      await todoList.addTodo("Task 1", "Content 1");
      await todoList.addTodo("Task 2", "Content 2");
      await todoList.addTodo("Task 3", "Content 3");
      await todoList.addTodo("Task 4", "Content 4");
      await todoList.addTodo("Task 5", "Content 5");
    });

    it("Should return only active todos", async function () {
      await todoList.completeTodo(0);
      await todoList.completeTodo(2);
      await todoList.completeTodo(4);
      
      const activeTodos = await todoList.getActiveTodos();
      
      expect(activeTodos.length).to.equal(2);
      expect(activeTodos[0].id).to.equal(1);
      expect(activeTodos[1].id).to.equal(3);
      expect(activeTodos[0].title).to.equal("Task 2");
      expect(activeTodos[1].title).to.equal("Task 4");
    });

    it("Should return empty array when all todos are completed", async function () {
      await todoList.completeTodo(0);
      await todoList.completeTodo(1);
      await todoList.completeTodo(2);
      await todoList.completeTodo(3);
      await todoList.completeTodo(4);
      
      const activeTodos = await todoList.getActiveTodos();
      expect(activeTodos.length).to.equal(0);
    });

    it("Should return all todos when none are completed", async function () {
      const activeTodos = await todoList.getActiveTodos();
      expect(activeTodos.length).to.equal(5);
    });
  });

  describe("Multiple users", function () {
    it("Should allow multiple users to add todos", async function () {
      await todoList.connect(alice).addTodo("Alice's Task", "Alice's Content");
      await todoList.connect(bob).addTodo("Bob's Task", "Bob's Content");
      
      expect(await todoList.getTodoCount()).to.equal(2);
      
      const todo1 = await todoList.getTodo(0);
      const todo2 = await todoList.getTodo(1);
      
      expect(todo1.title).to.equal("Alice's Task");
      expect(todo2.title).to.equal("Bob's Task");
    });

    it("Should handle multiple users completing todos", async function () {
      await todoList.connect(alice).addTodo("Alice's Task", "Content");
      await todoList.connect(bob).addTodo("Bob's Task", "Content");
      
      await todoList.connect(alice).completeTodo(0);
      
      const activeTodos = await todoList.getActiveTodos();
      expect(activeTodos.length).to.equal(1);
      expect(activeTodos[0].title).to.equal("Bob's Task");
    });
  });

  describe("Event history", function () {
    it("Should track all TodoAdded events", async function () {
      await todoList.addTodo("Task 1", "Content 1");
      await todoList.addTodo("Task 2", "Content 2");
      await todoList.addTodo("Task 3", "Content 3");
      
      const filter = todoList.filters.TodoAdded();
      const events = await todoList.queryFilter(filter);
      
      expect(events.length).to.equal(3);
      expect(events[0].args.id).to.equal(0n);
      expect(events[0].args.title).to.equal("Task 1");
      expect(events[1].args.id).to.equal(1n);
      expect(events[2].args.title).to.equal("Task 3");
    });

    it("Should track TodoCompleted events", async function () {
      await todoList.addTodo("Task 1", "Content 1");
      await todoList.addTodo("Task 2", "Content 2");
      await todoList.addTodo("Task 3", "Content 3");
      
      await todoList.completeTodo(0);
      await todoList.completeTodo(2);
      
      const filter = todoList.filters.TodoCompleted();
      const events = await todoList.queryFilter(filter);
      
      expect(events.length).to.equal(2);
      expect(events[0].args.id).to.equal(0n);
      expect(events[1].args.id).to.equal(2n);
    });
  });

  describe("Empty list", function () {
    it("Should handle empty todo list", async function () {
      expect(await todoList.getTodoCount()).to.equal(0);
      
      const activeTodos = await todoList.getActiveTodos();
      expect(activeTodos.length).to.equal(0);
    });
  });
});
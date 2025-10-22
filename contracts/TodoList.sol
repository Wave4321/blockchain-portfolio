// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract TodoList {
    struct Todo {
        uint id;
        string title;
        string content;
        bool isCompleted;
    }

    Todo[] public todos;
    uint public nextTodoId = 0;

    event TodoAdded(uint indexed id, string title);
    event TodoCompleted(uint indexed id);

    function addTodo(string memory _title, string memory _content) public {
        todos.push(Todo({
            id: nextTodoId,
            title: _title,
            content: _content,
            isCompleted: false
        }));
        
        emit TodoAdded(nextTodoId, _title);
        nextTodoId++;
    }

    function completeTodo(uint _todoId) public {
        require(_todoId < todos.length, "Invalid todo ID");
        require(!todos[_todoId].isCompleted, "Already completed");
        
        todos[_todoId].isCompleted = true;
        emit TodoCompleted(_todoId);
    }

    function getTodoCount() public view returns (uint) {
        return todos.length;
    }
    
    function getTodo(uint _id) public view returns (
        uint id,
        string memory title,
        string memory content,
        bool isCompleted
    ) {
        require(_id < todos.length, "Invalid todo ID");
        
        Todo memory todo = todos[_id];
        return (
            todo.id,
            todo.title,
            todo.content,
            todo.isCompleted
        );
    }
    
    function getActiveTodos() public view returns (Todo[] memory) {
        uint activeCount = 0;
        for (uint i = 0; i < todos.length; i++) {
            if (!todos[i].isCompleted) {
                activeCount++;
            }
        }
        
        Todo[] memory activeTodos = new Todo[](activeCount);
        
        uint index = 0;
        for (uint i = 0; i < todos.length; i++) {
            if (!todos[i].isCompleted) {
                activeTodos[index] = todos[i];
                index++;
            }
        }
        
        return activeTodos;
    }
}
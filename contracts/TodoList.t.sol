// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "./TodoList.sol";

contract TodoListTest is Test {
    TodoList public todoList;
    
    // ============ Setup ============
    function setUp() public {
        todoList = new TodoList();  // 힌트: 컨트랙트 이름
    }

    // ============ 테스트 1: 기본 Todo 추가 ============
    function testAddTodo() public {
        // Todo 추가
        todoList.addTodo("Study Solidity", "Learn arrays and structs");
        
        // 개수 검증
        assertEq(todoList.getTodoCount() , 1);  // 힌트: 개수 확인 함수
        
        // Todo 내용 검증
        (uint id, string memory title, string memory content, bool isCompleted) 
            = todoList.getTodo(0);  // 힌트: 첫 번째 ID
            
        assertEq(id, 0);
        assertEq(title, "Study Solidity");
        assertEq(content, "Learn arrays and structs");
        assertEq(isCompleted, false);  // 힌트: 처음엔 완료 안 됨
    }

    // ============ 테스트 2: 여러 Todo 추가 ============
    function testAddMultipleTodos() public {
        // 3개 추가
        todoList.addTodo("Task 1", "Content 1");
        todoList.addTodo("Task 2", "Content 2");
        todoList.addTodo("Task 3", "Content 3");
        
        // 개수 검증
        assertEq(todoList.getTodoCount(), 3);
        
        // 두 번째 Todo 검증 (id=1)
        (, string memory title, , ) = todoList.getTodo(1);  // 힌트: 조회 함수
        assertEq(title, "Task 2");
    }

    // ============ 테스트 3: Todo 완료 처리 ============
    function testCompleteTodo() public {
        // Todo 추가
        todoList.addTodo("Finish homework", "Math problems");
        
        // 완료 처리 전 상태
        (, , , bool isCompletedBefore) = todoList.getTodo(0);
        assertEq(isCompletedBefore, false);
        
        // 완료 처리
        todoList.completeTodo(0);  // 힌트: 완료 함수, ID는 0
        
        // 완료 처리 후 상태
        (, , , bool isCompletedAfter) = todoList.getTodo(0);
        assertEq(isCompletedAfter, true);  // 힌트: 완료됨
    }

    // ============ 테스트 4: 중복 완료 시도 (에러) ============
    function testCannotCompleteTwice() public {
        // Todo 추가 및 완료
        todoList.addTodo("Task", "Content");
        todoList.completeTodo(0);
        
        // 다시 완료 시도 → 에러 예상
        vm.expectRevert("Already completed");  // 힌트: 에러 예상 치트코드
        todoList.completeTodo(0);
    }

    // ============ 테스트 5: 잘못된 ID (에러) ============
    function testInvalidTodoId() public {
        // Todo가 없는데 조회 시도
        vm.expectRevert("Invalid todo ID");  // 힌트: 에러 메시지
        todoList.getTodo(0);
        
        // Todo 1개 추가
        todoList.addTodo("Task", "Content");
        
        // 존재하지 않는 ID 조회
        vm.expectRevert("Invalid todo ID");
        todoList.getTodo(1);  // 힌트: 1은 존재 안 함
    }

    // ============ 테스트 6: 미완료 Todo 필터링 ============
    function testGetActiveTodos() public {
        // 5개 Todo 추가
        todoList.addTodo("Task 1", "Content 1");
        todoList.addTodo("Task 2", "Content 2");
        todoList.addTodo("Task 3", "Content 3");
        todoList.addTodo("Task 4", "Content 4");
        todoList.addTodo("Task 5", "Content 5");
        
        // 일부만 완료 (0, 2, 4 완료)
        todoList.completeTodo(0);
        todoList.completeTodo(2);
        todoList.completeTodo(4);
        
        // 미완료 Todo 조회
        TodoList.Todo[] memory activeTodos = todoList.getActiveTodos();  // 힌트: 미완료 조회 함수
        
        // 검증: 2개만 남아야 함 (1, 3)
        assertEq(activeTodos.length, 2);  // 힌트: 2개
        assertEq(activeTodos[0].id, 1);   // 힌트: id 1
        assertEq(activeTodos[1].id, 3);
        assertEq(activeTodos[0].title, "Task 2");
        assertEq(activeTodos[1].title, "Task 4");
    }

    // ============ 테스트 7: 빈 리스트 ============
    function testEmptyList() public {
        // 개수 검증
        assertEq(todoList.getTodoCount(), 0);  // 힌트: 0개
        
        // 미완료 Todo 조회
        TodoList.Todo[] memory activeTodos = todoList.getActiveTodos();
        assertEq(activeTodos.length, 0);
    }

    // ============ 테스트 8: TodoAdded 이벤트 ============
    function testTodoAddedEvent() public {
        // 이벤트 예상
        vm.expectEmit(true, false, false, false);  // 힌트: indexed 파라미터 개수
        emit TodoList.TodoAdded(0, "New Task");  // 힌트: 이벤트 이름
        
        // Todo 추가
        todoList.addTodo("New Task", "Content");
    }

    // ============ 테스트 9: TodoCompleted 이벤트 ============
    function testTodoCompletedEvent() public {
        // Todo 추가
        todoList.addTodo("Task", "Content");
        
        // 이벤트 예상
        vm.expectEmit(true, false, false, true);
        emit TodoList.TodoCompleted(0);  // 힌트: 첫 번째 ID
        
        // 완료 처리
        todoList.completeTodo(0);
    }

    // ============ 테스트 10: Fuzz 테스트 ============
    function testFuzzAddTodo(string memory _title, string memory _content) public {
        // 랜덤 입력으로 추가
        todoList.addTodo(_title, _content);  // 힌트: 파라미터
        
        // 검증
        assertEq(todoList.getTodoCount(), 1);
        
        (, string memory title, string memory content, ) = todoList.getTodo(0);
        assertEq(title, _title);    // 힌트: 입력한 제목
        assertEq(content, _content);
    }

    // ============ 테스트 11: 다중 사용자 시뮬레이션 ============
    function testMultipleUsers() public {
        address alice = address(0x1);
        address bob = address(0x2);
        
        // Alice가 Todo 추가
        vm.prank(alice);  // 힌트: alice
        todoList.addTodo("Alice's Task", "Alice's Content");
        
        // Bob이 Todo 추가
        vm.prank(bob);  // 힌트: 사용자 전환
        todoList.addTodo("Bob's Task", "Bob's Content");
        
        // 검증: 총 2개
        assertEq(todoList.getTodoCount(), 2);
        
        // Alice의 Todo 완료
        vm.prank(alice);
        todoList.completeTodo(0);  // 힌트: 첫 번째
        
        // 미완료 Todo는 1개 (Bob's)
        TodoList.Todo[] memory activeTodos = todoList.getActiveTodos();
        assertEq(activeTodos.length, 1);  // 힌트: 1개
        assertEq(activeTodos[0].title, "Bob's Task");
    }
}
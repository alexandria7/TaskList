require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
                completed: false
  }

  # Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new task page" do
      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completed: false,
        },
      }
      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completed).must_equal task_hash[:task][:completed]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  # Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      get edit_task_path(task.id)
      # Assert
      must_respond_with :success
    end

    it "will respond with redirect when attempting to edit a nonexistant task" do
      get edit_task_path("Not a valid id!")

      must_respond_with :redirect
    end
  end

  describe "update" do
    it "can update an existing task" do
      task_change = {
        task: {
          name: "this is an updated name!",
          description: "this is a new description!",
        },
      }

      task_id = task.id
      patch task_path(task.id), params: task_change

      edited_task = Task.find_by(id: task_id)
      expect(edited_task.name).must_equal task_change[:task][:name]
      expect(edited_task.description).must_equal task_change[:task][:description]

      must_respond_with :redirect
      must_redirect_to task_path(task.id)
    end

    it "will redirect to the root page if given an invalid id" do
      invalid_task_id = -1
      patch task_path(invalid_task_id)
      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end

  # Wave 4
  describe "destroy" do
    it "returns a 404 error if a task is not found" do
      invalid_task_id = -1

      expect {
        delete task_path(invalid_task_id)
      }.must_change "Task.count", 0

      must_respond_with :not_found
    end

    it "can delete a task" do
      new_task = Task.create(name: "Delete this task")

      expect {
        delete task_path(new_task.id)
      }.must_change "Task.count", -1

      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end

  describe "toggle_complete" do
    it "changes the completion status of a task" do
      patch toggle_complete_path(task.id)

      task_with_changed_status = Task.find_by(id: task.id)

      expect(task_with_changed_status.completed).must_equal true

      must_respond_with :redirect
      must_redirect_to tasks_path
    end

    it "redirects to root page if task is not found" do
      invalid_task_id = -1
      patch toggle_complete_path(invalid_task_id)
      must_respond_with :redirect
      must_redirect_to tasks_path
    end
  end
end

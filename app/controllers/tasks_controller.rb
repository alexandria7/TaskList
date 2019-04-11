class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    task_id = params[:id].to_i
    @task = Task.find_by(id: task_id)

    if @task.nil?
      redirect_to tasks_path
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(
      name: params[:task][:name],
      description: params[:task][:description],
      completed: params[:task][:completed],
    )

    if @task.save
      redirect_to task_path(@task.id)
    else
      render :new
    end
  end

  def edit
    
  end

  def update
  end
end

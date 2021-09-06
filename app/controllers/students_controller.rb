class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_message
   rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_message
  def index
    render json: Student.all
  end
  def show
    student = Student.find(params[:id])
    render json: student
  end
  def create
    student = Student.create!(student_params)
    render json: student, status: :created
  end
  def update
    student = Student.find(params[:id])
    body = JSON.parse(request.body.read)
    body.each { |key, value| student[key] = value }
    student.save
    render json: student, status: 201
  end
  def destroy
    student = Student.find(params[:id])
    student.destroy
    head :no_content
  end

  private

  def record_not_found_message(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end
  def student_params
    params.permit(:name, :major, :age, :instructor_id)
  end
   def record_invalid_message(invalid)
   render json: { error: invalid.record.errors.full_messages }, status: :unprocessable_entity
 end
end

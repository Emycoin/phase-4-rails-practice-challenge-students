class InstructorsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_message
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_message
  def index
    render json: Instructor.all
  end

  def show
    instructor = Instructor.find(params[:id])
    render json: instructor
  end

  def create
    instructor = Instructor.create!(instructor_params)
    render json: instructor, status: :created
  end
  def update
    instructor = Instructor.find(params[:id])
    body = JSON.parse(request.body.read)
    body.each { |key, value| instructor[key] = value }
    instructor.save
    render json: instructor, status:201
  end
  def destroy
     instructor = Instructor.find(params[:id])
     instructor.destroy
     head :no_content
  end

  private

  def instructor_params
    params.permit(:name)
  end

  def record_not_found_message(exception)
    render json: { error: "#{exception.model} not found" }, status: :not_found
  end
  def record_invalid_message(invalid)
    render json: { error: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end

class HomeController < ApplicationController
  def index
    CalculatorJob.run(number1: params[:number1], number2: params[:number2])
    render json: {}, status: :ok
  end
end

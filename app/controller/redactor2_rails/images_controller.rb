class Redactor2Rails::ImagesController < ApplicationController
  before_action :redactor2_authenticate_user!

  def create
    @image = Redactor2Rails.image_model.new

    file = params[:file]
    @image.data = Redactor2Rails::Http.normalize_param(file, request)
    if @image.has_attribute?(:"#{Redactor2Rails.devise_user_key}")
      puts 'has attribute devise_user_key'
      @image.send("#{Redactor2Rails.devise_user}=", redactor_current_user)
      @image.assetable = redactor_current_user
    end

    puts 'Before Save'
    if @image.save
      puts 'SAVED!'
      render json: { id: @image.id, url: @image.url(:content) }
    else
      puts 'NOT SAVED!'
      puts "Errors: #{@image.errors.messages}"
      render json: { error: @image.errors }
    end
  end

  private

  def redactor2_authenticate_user!
    puts 'redactor2_authenticate_user!'
    if Redactor2Rails.image_model.new.has_attribute?(Redactor2Rails.devise_user)
      super
    end
  end
end

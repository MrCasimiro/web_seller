# frozen_string_literal: true

# Images Controller handles add and destroy images
# separates from the product, e.g, this controller is used
# when the user wants do update the product's image.
class ImagesController < ApplicationController
  before_action :authenticate_user!

  def new
    @images = Image.where(product_id: params[:product_id])
    @new_image = Image.new
  end

  def create
    @images = Image.where(product_id: params[:product_id])
    @new_image = Image.new(product_id: params[:product_id])
    @image = Image.new(image_params)
    flash.now[:info] = @image.save ? 'Imagem adicionada' : 'Ocorreu um erro'
    render 'new'
  end

  def destroy
    image = Image.find(params[:id])
    if Product.find(image.product_id).images.length > 1
      flash[:info] = image.destroy ? 'Imagem removida' : 'Ocorreu um erro'
    else
      flash[:danger] = 'O produto não pode ficar sem foto'
    end
    redirect_to root_path
  end

  private

  def image_params
    params.require(:image).permit(:product_id, :photo)
  end
end

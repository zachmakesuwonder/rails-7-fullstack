# frozen_string_literal: true

module Kit
  class ProductsController < ApplicationController
    before_action :load_kit_products, only: %i[index show new]
    before_action :set_kit_product, only: %i[show update destroy]

    # GET /kit/products or /kit/products.json
    def index
      @kit_product = @kit_products.first.reload
    end

    # GET /kit/products/1 or /kit/products/1.json
    def show
      respond_to do |format|
        format.html { render(:index) }
        format.json { render(:show) }
      end
    end

    # GET /kit/products/new
    def new
      @kit_product = Kit::Product.new

      render(:index)
    end

    # POST /kit/products or /kit/products.json
    def create
      @kit_product = Kit::Product.new(kit_product_params)

      respond_to do |format|
        if @kit_product.save
          format.html { redirect_to(kit_product_url(@kit_product), notice: 'Product was successfully created.') }
          format.json { render(:show, status: :created, location: @kit_product) }
        else
          format.html do
            load_kit_products

            render(:index, status: :unprocessable_entity)
          end
          format.json { render(json: @kit_product.errors, status: :unprocessable_entity) }
        end
      end
    end

    # PATCH/PUT /kit/products/1 or /kit/products/1.json
    def update
      respond_to do |format|
        if @kit_product.update(kit_product_params)
          format.html { redirect_to(kit_product_url(@kit_product), notice: 'Product was successfully updated.') }
          format.json { render(:show, status: :ok, location: @kit_product) }
        else
          format.html do
            load_kit_products

            render(:index, status: :unprocessable_entity)
          end
          format.json { render(json: @kit_product.errors, status: :unprocessable_entity) }
        end
      end
    end

    # DELETE /kit/products/1 or /kit/products/1.json
    def destroy
      @kit_product.destroy

      respond_to do |format|
        format.html { redirect_to(kit_products_url, notice: 'Product was successfully destroyed.') }
        format.json { head(:no_content) }
      end
    end

    private

    def load_kit_products
      @q = Kit::Product.ransack(params[:q])
      @pagy, @kit_products = pagy(@q.result)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_kit_product
      @kit_product = Kit::Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kit_product_params
      params.require(:kit_product).permit(:name)
    end
  end
end

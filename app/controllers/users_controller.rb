class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    def index
        if current_user.admin?
            @users = User.all
        end
    end
    
    def edit
        @roles = Role.all
    end
    
    def destroy
        @user.destroy
    end
    
    def update
        respond_to do |format|
          if @user.update(user_params)
            format.html { redirect_to users_path, notice: 'User was successfully updated.' }
            format.json { render :show, status: :ok, location: @user }
          else
            format.html { render :edit }
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
    end
  
    private
        def set_user
            if current_user.admin?
                @user = User.find(params[:id])
            end
        end
        
        def user_params
          params.require(:user).permit(:role_id)
        end
end

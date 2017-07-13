class Backoffice::AdminsController < BackofficeController
  before_action :set_admin, only: [:edit, :update, :destroy]

  def index
    @admins = Admin.all.order(:id)
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(params_admin)

    if @admin.save
      redirect_to backoffice_admins_path, notice: "O administrador (#{@admin.name}) foi cadastrado com sucesso!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @admin.update(params_admin)
      AdminMailer.update_email(current_admin, @admin).deliver_now
      redirect_to backoffice_admins_path, notice: "O administrador (#{@admin.name}) foi atualizado com sucesso!"
    else
      render :edit
    end
  end

  def destroy
    admin_email = @admin.email

    if @admin.destroy
      redirect_to backoffice_admins_path, notice: "O administrador (#{admin_email}) foi excluído com sucesso!"
    else
      render :index
    end
  end


  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def params_admin

    if password_blank?
      params[:admin].except!(:password, :password_confirmation)
    end

    params.require(:admin).permit(:name, :email, :password, :password_confirmation)
  end

  def password_blank?
    params[:admin][:password].blank? &&
    params[:admin][:password_confirmation].blank?
  end
end

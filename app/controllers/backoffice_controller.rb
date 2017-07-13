class BackofficeController < ApplicationController
  #Filtro para validar se o usuário é do tipo admin
  before_action :authenticate_admin!
  layout "backoffice"
end
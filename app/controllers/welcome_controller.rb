class WelcomeController < ApplicationController
  def index
  end

  #TODO trocar por servico
  def verifica_login(login, senha)
    return true
  end
  
  def login
    login = params[:login]
    senha = params[:senha]
    if verifica_login(login, senha)
      redirect_to :controller => :produtos, :action => :index
    else
      render :action => :login_invalido
    end
  end
end

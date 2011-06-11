class WelcomeController < ApplicationController
  def index
  end

  #HC
  def verifica_login(usuario, senha)
    client = HTTPClient.new
    response = client.get('http://server.felipegasparini.com/autenticacao/index.php?r=autenticacao/login&password='+senha+'&email='+usuario)
    resposta = ActiveSupport::JSON::decode(response.body).to_hash
    puts "%%%Requisição de serviço"
    puts resposta['erro']
    if resposta['erro'].blank?
      return resposta['cpf']
    else
      return nil
    end
  end
 
  
  def login
    login = params[:login]
    senha = params[:senha]
    if cpf = verifica_login(login, senha)
      c = Cliente.find(cpf)
      c.cpf = login
      session[:user] = c
      redirect_to :controller => :produtos, :action => :index
    else
      render :action => :login_invalido
    end
  end
end

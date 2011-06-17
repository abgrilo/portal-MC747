class ComprasController < ApplicationController
  # GET /compras
  # GET /compras.xml
  def index
  end

  #TODO serviço
  def tem_produto_no_estoque(id_produto)
    return Produto.soa_find_availability_by_id(id_produto, nil) > 0
  end

  #Edilson
  def consulta_credito_cliente (cpf)
    client = Savon::Client.new do
      wsdl.document = "http://www.supercontrole.com/747/wsConsultaCliente.asmx?WSDL"
    end
    resp = client.request :wsdl, :consulta_cliente do
      soap.body = {:token => "TESTE", :cpf => cpf}
    end
    resp.to_hash[:consulta_cliente_response][:consulta_cliente_result] == "0"
  end
  
  def calcula_prazo (endereco, produtos)
    client = Savon::Client.new do
      wsdl.document = "http://localhost:8069/ComponentLogistica/services/LogisticaEntrega?WSDL" # Nao conseguimos acessar remotamente o wsdl
    end
    resp = client.request :wsdl, :calcula_prazo do
      soap.body =  {:endereco => endereco, :produtos => produtos}
    end
    resp.to_hash[:calcula_prazo_response][:calcula_prazo_return].split("|")[1]
  end
  
  
  def verifica_cartao(value, card_number, security_code, owner_name, expiration_date, operator_id)
    client = HTTPClient.new
    response = client.get("http://localhost:8085/axis2/services/CreditCardService/CreditCardManager?value=#{value}&cardNumber=#{card_number}&securityCode=#{security_code}&ownerName=#{owner_name}&expirationDate=#{expiration_date}&operatorID=#{operator_id}".gsub(" ", "%20"))
    response.body.gsub(/.*<ns1:return>/, "").gsub(/<.*/, "").to_i > 0
  end
  
    
  # GET /compras/new
  # GET /compras/new.xml
  def new
    id_produto = params[:produto]
    
    if not tem_produto_no_estoque(id_produto)
      render :produto_indisponivel
      return
    end
    
    @data_entrega = calcula_prazo("2", "4")
    
    @preco_produto = 1.0
    @compra = Compra.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @compra }
    end
  end

  # GET /compras/1/edit
  def edit
    @compra = Compra.find(params[:id])
  end

  # POST /compras
  # POST /compras.xml
  def create
    preco_produto = params[:preco_produto]

    @compra = Compra.new(params[:compra])
     #TODO verificar crédito
    if  verifica_cartao(preco_produto, @compra.numero_cartao, @compra.codigo_seguranca, @compra.nome_titular, @compra.data_validade, @compra.bandeira_id)  || consulta_credito_cliente(session[:user].cpf) 
      redirect_to new_endereco_path
    else
      render :sem_credito      
    end

  end

end

class ContactsController < ApplicationController
  before_action :set_contact, only: [:create, :confirm]

  def index
    @contact = Contact.all
  end

  def new
    if params[:back]
      @contact = Contact.new(contact_params)
    elsif
      @contact = Contact.new
    end
  end

  def create
    if @contact.save
      flash[:success] = "お問い合わせが完了しました！"
      redirect_to root_path
    else
      render action: 'new'
    end
  end

  def confirm
    render action: 'new' if @contact.invalid?
  end

  private
    def contact_params
      params.require(:contact).permit(:name, :email, :content)
    end

    def set_contact
      @contact = Contact.new(contact_params)
    end
end

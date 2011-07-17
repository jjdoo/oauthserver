require 'digest/sha1'

class User < ActiveRecord::Base
  require 'rest_client'
  require 'json'
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken",:order=>"authorized_at desc",:include=>[:client_application]
 #establish_connection :other_db
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    #u = find_by_login(login.downcase) # need to get the salt
    #u && u.authenticated?(password) ? u : nil   
      # 登录接口 获取用户登录的session和用户id
     begin
     response = RestClient.post 'oray507.gicp.net:8892'+'/session',{'session[app_name]' => 'you','session[app_password]'=>'you_mobroad','session[username]' => login,'session[password]'=>password}
     p "respons"
    @user= JSON.parse response.body #获取的json解析方式
#    session[:usercookie]=response.cookies
#    session[:userid]=@user['entry']['user_id']
     p "@user=",@user
    userid = @user['entry']['user_id'] #用户id
    
    unless find_by_login(userid) then
      uinfo={"password_confirmation"=>"123456","login"=> userid,"password"=>"123456","email"=>userid+"@gmail.com"}
      p "uninfo"
      x=User.new(uinfo).save
      p x
      p "user.new(uinfo)"
    end
    #flash[:notice]="用户名或密码错误
    u = find_by_login(userid)
    return u

     rescue => e
       p e
           p "rais return"
       return nil
    end
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  
end

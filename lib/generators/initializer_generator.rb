class InitializerGenerator < Rails::Generators::NamedBase

  def create_initializer_file
    create_file "config/initializers/initializer.rb", "# Add initialization content here"
  end

  def scaffold_user_and_session
    generate "scaffold", "users name:string email:string remember_token:string"
    ganarate "controller", "sessions "
  end

end

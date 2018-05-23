Amber::Server.configure do |app|
  pipeline :web do
    # Ensure trailing slash in the URL
    plug Slashify.new
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Citrine::I18n::Handler.new
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug Amber::Pipe::CSRF.new
    # Reload clients browsers (development only)
    plug Amber::Pipe::Reload.new if Amber.env.development?

    plug Authenticate.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::PoweredByAmber.new
    # plug Amber::Pipe::ClientIp.new(["X-Forwarded-For"])
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Static.new("./public")
  end

  routes :web do
    # User stuff, autogenerated
    get "/profile", UserController, :show
    patch "/profile", UserController, :update
    get "/signinup", AuthController, :new
    post "/session", AuthController, :create
    get "/signout", AuthController, :delete
    post "/registration", AuthController, :register
    get "/", HomeController, :index
  end

  # Player section routes
  routes :web, "/nocturne" do
    get "/", PlayerController, :index
  end

  # Admin Panel Routes
  routes :web, "/admin" do
    get "/", AdminController, :index
    # Models
    # Build Queue
    get "/models/buildqueue/", BuildQueueAdminController, :index
    # Building
    get "/models/building/", BuildingAdminController, :index
    get "/models/building/new/", BuildingAdminController, :new
    post "/models/building/new/", BuildingAdminController, :create
    get "/models/building/:id/", BuildingAdminController, :read
    put "/models/building/:id/", BuildingAdminController, :update
    delete "/models/building/:id/", BuildingAdminController, :delete
    # Crafter
    get "/models/crafter/", CrafterAdminController, :index
    get "/models/crafter/new/", CrafterAdminController, :new
    post "/models/crafter/new/", CrafterAdminController, :create
    get "/models/crafter/:id/", CrafterAdminController, :read
    put "/models/crafter/:id/", CrafterAdminController, :update
    delete "/models/crafter/:id/", CrafterAdminController, :delete
    # Furnishing
    get "/models/furnishing/", FurnishingAdminController, :index
    get "/models/furnishing/new/", FurnishingAdminController, :new
    post "/models/furnishing/new/", FurnishingAdminController, :create
    get "/models/furnishing/:id/", FurnishingAdminController, :read
    put "/models/furnishing/:id/", FurnishingAdminController, :update
    delete "/models/furnishing/:id/", FurnishingAdminController, :delete
    # Resource
    get "/models/resource/", ResourceAdminController, :index
    get "/models/resource/new/", ResourceAdminController, :new
    post "/models/resource/new/", ResourceAdminController, :create
    get "/models/resource/:id/", ResourceAdminController, :read
    put "/models/resource/:id/", ResourceAdminController, :update
    delete "/models/resource/:id/", ResourceAdminController, :delete
    # Village
    get "/models/village/", VillageAdminController, :index
    get "/models/village/new/", VillageAdminController, :new
    post "/models/village/new/", VillageAdminController, :create
    get "/models/village/:id/", VillageAdminController, :read
    put "/models/village/:id/", VillageAdminController, :update
    delete "/models/village/:id/", VillageAdminController, :delete

    # Relations
    get "/relations/buildqueuebuilding/", BuildQueueBuildingAdminController, :index
    get "/relations/buildingfurnishing/", BuildingFurnishingAdminController, :index
    get "/relations/buildingrequirement/", BuildingRequirementAdminController, :index
    get "/relations/buildingresource/", BuildingResourceAdminController, :index
    get "/relations/requiredcrafter/", RequiredCrafterAdminController, :index
    get "/relations/residingcrafter/", ResidingCrafterAdminController, :index
    get "/relations/resourcestore/", ResourceStoreAdminController, :index
    get "/relations/villagebuilding/", VillageBuildingAdminController, :index
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", Amber::Controller::Static, :index
  end
end

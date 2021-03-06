enum struct VehicleProperties
{
	int entity;
	ArrayList passengers;
	
	void Initialize(int entity)
	{
		this.entity = entity;
		this.passengers = new ArrayList(_, MaxClients);
	}
	
	void Destroy()
	{
		delete this.passengers;
	}
}

static ArrayList g_VehicleProperties;

methodmap Vehicle
{
	public Vehicle(int entity)
	{
		if (!IsValidEntity(entity))
			return view_as<Vehicle>(INVALID_ENT_REFERENCE);
		
		entity = EntIndexToEntRef(entity);
		
		if (g_VehicleProperties.FindValue(entity, VehicleProperties::entity) == -1)
		{
			LogMessage("Creating vehicle %d", entity);
			
			//Initialize vehicle properties (and their default values)
			VehicleProperties properties;
			properties.Initialize(entity);
			
			g_VehicleProperties.PushArray(properties);
		}
		
		return view_as<Vehicle>(entity);
	}
	
	property ArrayList Passengers
	{
		public get()
		{
			int index = g_VehicleProperties.FindValue(view_as<int>(this), VehicleProperties::entity);
			return g_VehicleProperties.Get(index, VehicleProperties::passengers);
		}
		public set(ArrayList value)
		{
			int index = g_VehicleProperties.FindValue(view_as<int>(this), VehicleProperties::entity);
			g_VehicleProperties.Set(index, value, VehicleProperties::passengers);
		}
	}
	
	public void Destroy()
	{
		LogMessage("Destroying vehicle %d", view_as<int>(this));
		
		int index = g_VehicleProperties.FindValue(view_as<int>(this), VehicleProperties::entity);
		
		VehicleProperties properties;
		if (g_VehicleProperties.GetArray(index, properties) > 0)
			properties.Destroy();
		
		g_VehicleProperties.Erase(index);
	}
	
	public static void InitializePropertyList()
	{
		g_VehicleProperties = new ArrayList(sizeof(VehicleProperties));
	}
}

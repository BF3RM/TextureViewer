class 'TextureViewerClient'

function TextureViewerClient:__init()
	print("Initializing textureviewerClient")
	self:RegisterVars()
	self:RegisterEvents()
end

function TextureViewerClient:RegisterVars()
	self.m_Textures = {}
end

function TextureViewerClient:RegisterEvents()
	Events:Subscribe('Extension:Loaded', self, self.OnLoaded)
	Events:Subscribe('Level:Loaded', self, self.OnLevelLoaded)
	Events:Subscribe('Partition:Loaded', self, self.OnPartitionLoaded)

end

function TextureViewerClient:OnLevelLoaded()

	WebUI:EnableMouse()
	print("faaack")
	for _,l_Texture in ipairs(self.m_Textures) do
		print(l_Texture)
		WebUI:ExecuteJS("AddImage(\""..l_Texture.."\")")
	end
end

function TextureViewerClient:OnLoaded()
	WebUI:Init()
	WebUI:Show()
	WebUI:BringToFront()
end

function TextureViewerClient:OnPartitionLoaded(p_Partition)
    for _, l_Instance in pairs(p_Partition.instances) do
        if l_Instance ~= nil and l_Instance:Is("TextureAsset") then
			self:CallOrRegisterLoadHandler(l_Instance, self.HandleTextureAsset)
		end
    end
end

function TextureViewerClient:CallOrRegisterLoadHandler(p_Instance, p_Handler)
	if p_Instance.isLazyLoaded then
		p_Instance:RegisterLoadHandlerOnce(self, p_Handler)
	else
		p_Handler(self, p_Instance)
	end
end

function TextureViewerClient:HandleTextureAsset(p_Instance)
	-- 3ti: it will crash after loading, if you dont filter. this filters for background trees (kinda)
	if (string.match(p_Instance.name:lower(), 'tree') or string.match(p_Instance.name:lower(), '2d') or string.match(p_Instance.name:lower(), 'undergrowth') or (string.match(p_Instance.name:lower(), 'backdrop') and string.match(p_Instance.name:lower(), 'characterbackdrop') == false)) then
		print(p_Instance.name)
		table.insert(self.m_Textures, tostring(p_Instance.name))
	end
end

g_TextureViewerClient = TextureViewerClient()


local CarbineBankModule = SenorPlow:NewModule("CarbineBankModule")

function CarbineBankModule:OnEnable()
	if Apollo.GetAddonInfo("BankViewer").bRunning ~= 0 then self.Parent.bank = Apollo.GetAddon("BankViewer")  end
end

function CarbineBankModule:WindowManagementAdd(name, args)
	if args.strName = Apollo.GetString("Bank_Header") then return end
end
--Mission 4: Token Minting Handler
-- Description: Allow the contract owner to mint (create) new tokens.

Handlers.add(
    "mint",
    Handlers.utils.hasMatchingTag("Action", "Mint"),
    function(msg)
        assert(type(msg.Tags.Quantity) == "string", "Quantity is required!")

        local qty = tonumber(msg.Tags.Quantity)
        assert(qty and qty > 0, "Quantity must be a positive number!")

        -- Only allow the Owner to mint new tokens:
        if msg.From == Owner then
            if not Balances[Owner] then Balances[Owner] = 0 end

            -- Increase balance and total supply
            Balances[Owner] = Balances[Owner] + qty
            TotalSupply = TotalSupply + qty

            -- Confirmation message
            ao.send({
                Target = Owner,
                Tags   = { Action = "MintSuccess", Amount = tostring(qty), NewSupply = tostring(TotalSupply) }
            })
        else
            -- Unauthorized mint attempt
            ao.send({
                Target = msg.From,
                Tags   = { Action = "Mint-Error", Error = "Only the Owner can mint new tokens!" }
            })
        end
    end
)

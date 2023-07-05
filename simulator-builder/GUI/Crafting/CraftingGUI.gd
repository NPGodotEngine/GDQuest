extends MarginContainer

const CraftingItem := preload("CraftingRecipeItem.tscn")

var gui: Control

onready var items := $PanelContainer/CraftingList/ScrollContainer/VBoxContainer

func setup(_gui: Control) -> void:
    gui = _gui

func update_recipes() -> void:
    # We free all existing recipes to start from a clean state.
    for child in items:
        child.queue_free()
    
    # We loop over every available recipe name.
    for output in Recipes.Crafting.keys():
        var recipe: Dictionary = Recipes.Crafting[output]

        # We default to true, and then iterate over each item. If at any point
        # it turns out false, then we can skip the item.
        var can_craft := true 

        # For each required material in the recipe, we ensure the player has enough of it.
        # If not, they can't craft the item and we move to the next recipe.
        for input in recipe.input.keys():
            if not gui.is_in_inventory(input, recipe.inputs[input]):
                can_craft = false
                break
        
        if not can_craft:
            continue

        # We temporarily instance the blueprint to acess its sprite and data.
        var temp: BlueprintEntity = Library.blueprints[output].instance()

        # We then instantiate the recipe item and add it to the scene tree.
        var item := CraftingItem.instance()
        items.add_child(item)

        # We grab the blueprint's sprite.
        var sprite: Sprite = temp.get_node("Sprite")

        # And we use the sprite to set up the recipe item with the name,
        # texture, and sprite region information.
        item.setup(
            Library.get_entity_name_from(temp),
            sprite.texture,
            sprite.region_enabled,
            sprite.region_rect
        )
        
        # And finally, we free the temporary blueprint as we don't need it
        # anymore.
        temp.free()
terraform {
  required_providers {
    dnd5e = {
      source  = "alisdair/dnd5e"
      version = "1.0.1"
    }
  }

  cloud {
    organization = "mars-test-org"

    workspaces {
      name = "gh-actions-demo"
    }
  }
}

variable "battle_ready" {
  type    = bool
  default = true
}

variable "party_xp" {
  type    = number
  default = 0
}

variable "kobold_count" {
  type    = number
  default = 4
}

resource "dnd5e_character" "julia" {
  name              = "Julia Axereaver"
  class             = "druid"
  alignment         = "lawful good"
  experience_points = var.party_xp
  strength          = 13
  dexterity         = 9
  constitution      = 12
  intelligence      = 19
  wisdom            = 17
  charisma          = 10

  inventory_item {
    name        = "studded leather armor"
    armor_class = 16
    equipped    = var.battle_ready
    weight      = 10
  }

  inventory_item {
    name   = "amulet of yendor"
    weight = 1
  }

  inventory_item {
    name     = "staff of nature"
    equipped = var.battle_ready
    weight   = 1
  }

  inventory_item {
    name   = "cooking pot"
    weight = 1
  }

  inventory_item {
    name        = "nature's greaves"
    armor_class = 2
    equipped    = var.battle_ready
    weight      = 1
  }

  skills = {
    "religion"        = 3
    "animal handling" = 1
    "nature"          = 1
    "survival"        = 2
  }

  spells = [
    "produce flame",
    "summon monster",
    "speak to animals",
    "Melf's acid arrow",
    "thunderwave",
    "cure wounds",
  ]
}

resource "dnd5e_character" "potato" {
  name              = "Potato Salad"
  class             = "fighter"
  alignment         = "neutral good"
  experience_points = var.party_xp
  strength          = 18
  dexterity         = 12
  constitution      = 14
  intelligence      = 10
  wisdom            = 8
  charisma          = 9

  inventory_item {
    name        = "plate armor"
    armor_class = 18
    equipped    = var.battle_ready
    weight      = 30
  }

  inventory_item {
    name        = "iron helm"
    armor_class = 4
    equipped    = var.battle_ready
    weight      = 1
  }

  inventory_item {
    name     = "halberd"
    equipped = var.battle_ready
    weight   = 4
  }

  inventory_item {
    name   = "cooking pot"
    weight = 1
  }
}

resource "dnd5e_character" "tiger" {
  name              = "Temporary Tiger"
  class             = "fighter"
  alignment         = "lawful good"
  experience_points = var.party_xp
  strength          = 17
  dexterity         = 10
  constitution      = 14
  intelligence      = 12
  wisdom            = 8
  charisma          = 10

  inventory_item {
    name        = "chainmail armor"
    armor_class = 17
    equipped    = var.battle_ready
    weight      = 25
  }

  inventory_item {
    name        = "chainmail helm"
    armor_class = 4
    equipped    = var.battle_ready
    weight      = 1
  }

  inventory_item {
    name   = "bonded greataxe"
    weight = 3
  }

  inventory_item {
    name   = "bagpipes"
    weight = 0
  }
}

# resource "dnd5e_character" "phil" {
#   name              = "Dr Phil"
#   class             = "rogue"
#   alignment         = "chaotic neutral"
#   experience_points = var.party_xp
#   strength          = 12
#   dexterity         = 19
#   constitution      = 12
#   intelligence      = 8
#   wisdom            = 8
#   charisma          = 11

#   inventory_item {
#     name        = "leather armor"
#     armor_class = 13
#     equipped    = var.battle_ready
#     weight      = 4
#   }

#   inventory_item {
#     name        = "wraith's crown"
#     armor_class = -1
#     equipped    = var.battle_ready
#     weight      = 1
#   }

#   inventory_item {
#     name     = "dragon slayer rapier"
#     equipped = var.battle_ready
#     weight   = 1
#   }

#   inventory_item {
#     name   = "1000 ball bearings"
#     weight = 0
#   }
# }

resource "dnd5e_character" "kobold" {
  count             = var.kobold_count
  name              = "Kobold dragonshield"
  class             = "fighter"
  alignment         = "lawful evil"
  experience_points = 3000
  strength          = 12
  dexterity         = 15
  constitution      = 14
  intelligence      = 8
  wisdom            = 9
  charisma          = 10

  inventory_item {
    name        = "leather armor"
    armor_class = 13
    equipped    = true
    weight      = 10
  }

  inventory_item {
    name        = "leather shield"
    armor_class = 3
    equipped    = true
    weight      = 1
  }

  provisioner "local-exec" {
    command = "sleep ${5 + count.index * 3}"
  }
}

resource "dnd5e_roll" "initiative" {
  modifier = dnd5e_character.julia.dexterity_modifier
}

resource "dnd5e_roll" "attack" {
  modifier = dnd5e_character.julia.strength_modifier
}

resource "dnd5e_roll" "damage" {
  number   = 3
  sides    = 8
  modifier = dnd5e_character.julia.strength_modifier
}

output "initiative" {
  value = dnd5e_roll.initiative.total
}

output "attack" {
  value = dnd5e_roll.attack.total
}

output "damage" {
  value = "${join("+", dnd5e_roll.damage.values)} + ${dnd5e_roll.damage.modifier} = ${dnd5e_roll.damage.total}"
}

output "party_info" {
  value = {
    "julia" = {
      "dex": dnd5e_character.julia.dexterity_modifier,
      "ac": dnd5e_character.julia.armor_class,
      "spells": length(dnd5e_character.julia.spells),
    },
    "potato" ={
      "dex": dnd5e_character.potato.dexterity_modifier,
      "ac": dnd5e_character.potato.armor_class,
      "spells": 0,
    },
    "tiger" = {
      "dex": dnd5e_character.tiger.dexterity_modifier,
      "ac": dnd5e_character.tiger.armor_class,
      "spells": 0,
    },
    # "phil" = {
    #   "dex": dnd5e_character.phil.dexterity_modifier,
    #   "ac": dnd5e_character.phil.armor_class,
    #   "spells": 0,
    # },
  }
}

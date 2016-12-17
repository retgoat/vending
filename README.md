# Vending


## Starting

```ruby
mix deps.get

iex -S mix
```

Then go to [http://localhost:8880](http://localhost:8880)

## Using

**Get all products**

*Request*

`GET http://localhost:8880/products`

*Response*

```json
[
  {
    "price": {
        "currency": "BKZ",
        "amount": 3
    },
    "name": "Tiny's used spacecraft",
    "id": 1
  },
  {
    "price": {
        "currency": "BKZ",
        "amount": 7
    },
    "name": "Sandskimmer",
    "id": 2
  },
  {
    "price": {
        "currency": "BKZ",
        "amount": 9
    },
    "name": "The escape Pod",
    "id": 3
  },
  {
    "price": {
        "currency": "BKZ",
        "amount": 12
    },
    "name": "Drallion Asteroid Cruiser",
    "id": 4
  },
  {
    "price": {
        "currency": "BKZ",
        "amount": 15
    },
    "name": "Arcada, the Federal spacelab",
    "id": 5
  }
]
```

**Get available cash nominals**

*Request*

`GET http://localhost:8880/cash/nominals`

*Response*

```json
{
    "nominals": [
        0.1,
        0.25,
        0.5,
        1,
        2,
        5,
        10
    ],
    "currency": "BKZ"
}
```

**Insert cash**

*Request*

`PUT http://localhost:8880/cash`

```json
{
  "cash": 2
}
```

*Response*

```json
{
    "products": [
        {
            "price": {
                "currency": "BKZ",
                "amount": 3
            },
            "name": "Tiny's used spacecraft",
            "id": 1
        }
    ],
    "cash": {
        "currency": "BKZ",
        "amount": 4
    }
}
```

**Get inserted cash**

*Request*

`GET http://localhost:8880/cash/given`

*Response*

```json
{
    "already_given": {
        "currency": "BKZ",
        "amount": 4
    }
}
```

**Purchase**

*Request*

`GET http://localhost:8880/products/:product_id/purchase`

*Response*

Product purchased successfully

```json
{
    "price": {
        "currency": "BKZ",
        "amount": 3
    },
    "odd_money": {
        "currency": "BKZ",
        "amount": 1
    },
    "name": "Tiny's used spacecraft",
    "id": 1
}
```

Purchase error

```json
{
    "error": "Can not purchase: not enough money"
}
```
![diagram](https://github.com/retgoat/vending/raw/master/static/images/vending-diagram.png "Vending machine diagram")



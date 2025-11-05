//RETO 1
db.bands.insertMany([
  {
    name: 'Soda Stereo',
    year: 1982,
    country: 'Argentina',
    albums: [
      {
        name: 'Nada Personal',
        songs: [ 'Cuando Pase el Temblor', 'Imagenes Retro' ],
        year: 1985,
        rating: 4.5,
        sales: 150000
      },
      {
        name: 'Signos',
        songs: [ 'Persiana Americana', 'El Rito' ],
        year: 1986,
        rating: 4.8,
        sales: 250000
      }
    ],
    members: [ 'Gustavo Cerati', 'Zeta Bosio', 'Charly Alberti' ]
  },
  {
    name: 'Seru Giran',
    year: 1978,
    country: 'Argentina',
    albums: [
      {
        name: 'Peperina',
        songs: [ 'Esperando Nacer', 'Cinema Verite' ],
        year: 1981,
        rating: 4.6,
        sales: 350000
      },
      {
        name: 'La Grasa de las Capitales',
        songs: [ 'Paranoia y Soledad', 'Frecuencia Modulada' ],
        year: 1971,
        rating: 4.8,
        sales: 550000
      }
    ]
  },
  {
    name: 'The Beatles',
    year: 1960,
    country: 'England',
    albums: [
      {
        name: 'Abbey Road',
        songs: [ 'Come Together', 'Something' ],
        rating: 5,
        sales: 600000
      },
      {
        name: 'Let it Be',
        songs: [ 'Across the Universe', "I've Got A Feeling" ],
        rating: 4.3,
        sales: 450000
      }
    ]
  }
])

//RETO 2 albumes por banda
db.bands.aggregate([
    {$project : 
        {"name" : 1, "numAlbums" : {$size : "$albums"}}
    }
])

//RETO 3 top 2 ventas
db.bands.aggregate([
    { $unwind: "$albums" },
    { $project: { "name": 1, "albumName": "$albums.name", "sales": "$albums.sales" } },
    { $sort: { "sales": -1 } },
    {$limit: 2}
])

//RETO 4 rating promedio por pais
db.bands.aggregate([
    {$unwind : "$albums"},
    {$project : {"country" : 1, "rating" : "$albums.rating"}},
    {$group : {"_id" : "$country", "avgRating" : {$avg : "$rating"}}}
])

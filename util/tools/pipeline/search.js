const searchPipeline = (where) => [
  {
    $searchBeta: {
      compound: {
        should: [
          {
            text: {
              query: where.search,
              path: 'title',
              fuzzy: {
                maxEdits: 2,
                prefixLength: 1,
              },
              score: {
                boost: {
                  value: 5,
                },
              },
            },
          },
          {
            text: {
              query: where.search,
              path: ['title', 'make', 'model', 'description', 'color', 'dimensions'],
            },
          },
        ],
      },
      highlight: {
        path: ['title', 'make', 'model', 'description', 'color', 'dimensions'],
      },
    },
  },
  {
    $project: {
      _id: 1,
      title: 1,
      make: 1,
      model: 1,
      color: 1,
      dimensions: 1,
      weight: 1,
      description: 1,
      location: 1,
      category: 1,
      price: 1,
      unitOfMeasure: 1,
      quantity: 1,
      userId: 1,
      url: 1,
      photo: 1,
      createdAt: 1,
      score: {
        $meta: 'searchScore',
      },
      highlight: {
        $meta: 'searchHighlights',
      },
    },
  },
  {
    $limit: 10,
  },
];

export default searchPipeline;

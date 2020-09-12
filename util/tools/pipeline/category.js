const categoryPipeline = (category, limit) => [
  {
    $match: {
      $and: [{ category: { $in: [category] } }],
    },
  },
  { $sort: { createdAt: -1 } },
  { $limit: limit + 1 },
];

export default categoryPipeline;

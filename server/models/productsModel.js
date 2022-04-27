// const featuresModel = require('./featuresModel'); // import more models
// const stylesModel = require('./featuresModel'); // import more models

const productsModel = (sequelize, { DataTypes }) => {
  const Product = sequelize.define('product', {
    id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      unique: true,
      primaryKey: true,
      validate: {
        notEmpty: true,
      },
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    slogan: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    description: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    category: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    default_price: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  });

  // Product.associate = (models) => {
  //   Product.hasMany(models.Features, { onDelete: 'CASCADE' });
  // };

  Product.allProducts = async () => {
    const products = await Product.findAll({
      limit: 10, // will need to remove when ready for final release
      attributes: { exclude: ['createdAt', 'updatedAt'] },
    });
    return products;
  };

  Product.findById = async (productId) => {
    const product = await Product.findOne({
      where: { id: productId }, // consider omitting created_at & updated_at colns
      attributes: { exclude: ['createdAt', 'updatedAt'] },
    });
    return product;
  };

  return Product;
};

// export default productsModel;
module.exports = productsModel;

/*
  Product.findById = async (productId) => {
    const product = JSON.stringify(await Product.findOne({
      where: { id: productId }, // consider omitting created_at & updated_at colns
    }));
    // hoping to be an arr of objs dbModels.models.Product.findById
    product.features = JSON.stringify(
      await dbModels.models.Features.findFeaturesByProductId(productId),
    );
    // product.features = features;
    console.log('product (clean from metadata) from sequelize: ', product);
    return product;
  };
  */

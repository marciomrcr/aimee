import fastify, { FastifyInstance } from "fastify";
import ShortUniqueId from "short-unique-id";
import { z } from "zod";
import { prisma } from "../lib/prisma";

export async function productRoutes(fastify: FastifyInstance) {
  fastify.get("/produtos", async (request) => {
    const searchProducts = await prisma.product.findMany({
      select: {
        name: true,
        min_stock: true,
        salePrice: true,
        purchasePrice: true,
      },

      orderBy: {
        name: "asc",
      },
    });

    return { searchProducts };
  });

  fastify.get("/produtos-categoria", async (request) => {
    const searchProducts = await prisma.product.findMany({
      select: {
        name: true,
        min_stock: true,
        salePrice: true,
        purchasePrice: true,
        category_product: {
          select: {
            category: {
              select: {
                name: true,
              },
            },
          },
        },
      },

      orderBy: {
        name: "asc",
      },
    });

    return { searchProducts };
  });

  fastify.get("/produtos/count", async () => {
    const count = await prisma.product.count();

    return { count };
  });

  fastify.post("/produtos", async (request, reply) => {
    const createProductBody = z.object({
      name: z.string(),
      description: z.string(),
      categoryId: z.string(),
      size: z.string(),
      colors: z.string(),
      min_stock: z.number(),
      purchasePrice: z.number(),
      salePrice: z.number(),
    });

    const {
      name,
      description,
      categoryId,
      size,
      colors,
      min_stock,
      purchasePrice,
      salePrice,
    } = createProductBody.parse(request.body);

    const productExists = await prisma.product.findUnique({
      where: {
        name,
      },
    });

    const categoryExists = await prisma.category.findUnique({
      where: {
        id: categoryId,
      },
    });

    if (!categoryExists) {
      return reply.status(400).send({ message: "Categoria não existe" });
    }

    if (productExists) {
      return reply.status(400).send({ message: "Produto já existe" });
    }

    const product = await prisma.category.findUnique({
      where: {
        id: categoryId,
      },
      include: {
        category_product: {
          where: {
            categoryId,
          },
        },
      },
    });

    const generate = new ShortUniqueId({ length: 6 });
    const code = String(generate()).toUpperCase();

    await prisma.product.create({
      data: {
        code,
        name,
        description,
        categoryId,
        size,
        colors,
        min_stock,
        purchasePrice,
        salePrice,
        category_product: {
          create: {
            categoryId,
          },
        },
      },
    });

    return reply.status(201).send({ name, code, salePrice });
  });
}

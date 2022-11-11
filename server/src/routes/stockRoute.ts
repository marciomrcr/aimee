import fastify, { FastifyInstance } from "fastify";
import ShortUniqueId from "short-unique-id";
import { z } from "zod";
import { prisma } from "../lib/prisma";

export async function stockRoutes(fastify: FastifyInstance) {
  fastify.get("/estoque", async (request) => {
    const searchStockProducts = await prisma.stock.findMany({
      select: {
        code: true,
        amount: true,
        product: {
          select: {
            name: true,
            min_stock: true,
            salePrice: true,
          },
        },
      },

      orderBy: {
        product: {
          name: "asc",
        },
      },
    });

    return { searchStockProducts };
  });

  // fastify.get("/estoque-categoria", async (request) => {
  //   const searchProducts = await prisma.stock.findMany({
  //     select: {
  //       name: true,
  //       min_stock: true,
  //       salePrice: true,
  //       purchasePrice: true,
  //       category_product: {
  //         select: {
  //           category: {
  //             select: {
  //               name: true,
  //             },
  //           },
  //         },
  //       },
  //     },

  //     orderBy: {
  //       name: "asc",
  //     },
  //   });

  //   return { searchProducts };
  // });

  fastify.get("/estoque/count", async () => {
    const count = await prisma.stock.count();

    return { count };
  });

  fastify.post("/estoque", async (request, reply) => {
    const createProductBody = z.object({
      amount: z.number(),
      productId: z.string(),
      min_stock: z.number(),
    });

    const { amount, productId, min_stock } = createProductBody.parse(
      request.body
    );

    const productExists = await prisma.product.findUnique({
      where: {
        id: productId,
      },
    });

    if (!productExists) {
      return reply.status(400).send({ message: "Produto não cadastrado!" });
    }

    const generate = new ShortUniqueId({ length: 6 });
    const code = String(generate()).toUpperCase();

    await prisma.stock.create({
      data: {
        code,
        productId,
        amount,
        min_stock,
      },
    });

    return reply.status(201).send({ code, productId, amount, min_stock });
  });
}

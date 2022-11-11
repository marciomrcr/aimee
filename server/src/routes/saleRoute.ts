import fastify, { FastifyInstance } from "fastify";
import ShortUniqueId from "short-unique-id";
import { z } from "zod";
import { prisma } from "../lib/prisma";

export async function saleRoutes(fastify: FastifyInstance) {
  fastify.get("/vendas", async (request) => {
    const searchSales = await prisma.sale.findMany({
      select: {
        code: true,
        consumer: {
          select: {
            name: true,
          },
        },
        sum_total: true,
        count_itens: true,
        sale_product: {
          select: {
            product: {
              select: {
                name: true,
                salePrice: true,
              },
            },
          },
        },
      },

      orderBy: {
        createdAt: "asc",
      },
    });

    return { searchSales };
  });

  // fastify.get("/vendas-produtos", async (request) => {
  //   const searchSaleProducts = await prisma.sale.findMany({
  //     select: {
  //       code: true,
  //       sum_total: true,
  //       count_itens: true,
  //     },

  //     orderBy: {
  //       createdAt: "asc",
  //     },
  //   });

  //   return { searchSaleProducts };
  // });

  fastify.get("/vendas/count", async () => {
    const countSales = await prisma.sale.count();

    return { countSales };
  });

  fastify.post("/vendas", async (request, reply) => {
    const createSaleBody = z.object({
      consumerId: z.string(),
      sum_total: z.number(),
      count_itens: z.number(),
    });

    const { consumerId } = createSaleBody.parse(request.body);

    const consumerExists = await prisma.consumer.findUnique({
      where: {
        id: consumerId,
      },
    });

    if (!consumerExists) {
      return reply.status(400).send({ message: "Cliente não encontrado" });
    }

    const generate = new ShortUniqueId({ length: 6 });
    const code = String(generate()).toUpperCase();

    const sum_total = () => {
      return 1;
    };
    const count_itens = () => {
      return 1;
    };

    await prisma.sale.create({
      data: {
        code,
        consumerId,
      },
    });

    return reply.status(201).send({ name, code, salePrice });
  });
}

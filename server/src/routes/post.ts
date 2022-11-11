import fastify, { FastifyInstance } from "fastify";
import ShortUniqueId from "short-unique-id";
import { z } from "zod";
import { prisma } from "../lib/prisma";

export async function postRoutes(fastify: FastifyInstance) {
  fastify.get("/posts", async () => {
    const searchCategories = await prisma.post.findMany({
      select: {
        title: true,
        id: true,
        categorias: {
          select: {
            category: {
              select: {
                name: true,
              },
            },
          },
        },
      },
      // include: {
      //   category_product: {
      //     include: {
      //       product: {
      //         select: {
      //           name: true,
      //         },
      //       },
      //     },
      //   },
      // },
      orderBy: {
        title: "asc",
      },
    });

    return { searchCategories };
  });
  fastify.get("/posts/count", async () => {
    const count = await prisma.category.count();

    return { count };
  });
}

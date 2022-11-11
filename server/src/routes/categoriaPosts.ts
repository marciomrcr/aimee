import fastify, { FastifyInstance } from "fastify";
import ShortUniqueId from "short-unique-id";
import { z } from "zod";
import { prisma } from "../lib/prisma";

export async function categoriaPostsRoutes(fastify: FastifyInstance) {
  fastify.get("/categoriaPosts", async () => {
    const searchCategories = await prisma.categoria.findMany({
      select: {
        name: true,

        posts: {
          select: {
            post: {
              select: {
                title: true,
              },
            },
          },
        },
      },

      orderBy: {
        name: "asc",
      },
    });

    return { searchCategories };
  });
}

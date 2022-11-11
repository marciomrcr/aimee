import fastify, { FastifyInstance } from "fastify";
import ShortUniqueId from "short-unique-id";
import { z } from "zod";
import { prisma } from "../lib/prisma";

export async function categoryRoutes(fastify: FastifyInstance) {
  fastify.get("/categorias", async () => {
    const searchCategories = await prisma.category.findMany({
      select: {
        name: true,
        id: true,
      },
      orderBy: {
        name: "asc",
      },
    });

    return { searchCategories };
  });
  fastify.get("/categorias-produtos", async () => {
    const searchCategories = await prisma.category.findMany({
      select: {
        name: true,
        category_product: {
          select: {
            product: {
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

    return { searchCategories };
  });

  fastify.get("/categoria/count", async () => {
    const count = await prisma.category.count();

    return { count };
  });

  fastify.post("/category", async (request, reply) => {
    const createCategoryBody = z.object({
      name: z.string(),
    });

    const { name } = createCategoryBody.parse(request.body);

    const categoryExists = await prisma.category.findUnique({
      where: {
        name,
      },
    });

    if (categoryExists) {
      return reply.status(400).send({ message: "Categoria já existe" });
    }

    await prisma.category.create({
      data: {
        name,
      },
    });

    return reply.status(201).send({ name });
  });
}

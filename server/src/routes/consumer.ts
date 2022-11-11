import fastify, { FastifyInstance } from "fastify";
import ShortUniqueId from "short-unique-id";
import { z } from "zod";
import { prisma } from "../lib/prisma";

export async function clienteRoutes(fastify: FastifyInstance) {
  fastify.get("/clientes", async () => {
    const searchClientes = await prisma.consumer.findMany({
      orderBy: {
        name: "asc",
      },
      select: {
        name: true,
        phone: true,
        address: true,
        id: true,
      },
    });

    return { searchClientes };
  });
  fastify.get("/clientes/count", async () => {
    const count = await prisma.consumer.count();

    return { count };
  });

  fastify.post("/clientes", async (request, reply) => {
    const createClienteBody = z.object({
      name: z.string(),
      phone: z.string(),
      address: z.string(),
    });

    const { name, phone, address } = createClienteBody.parse(request.body);

    await prisma.consumer.create({
      data: {
        name,
        phone,
        address,
      },
    });

    return reply.status(201).send({ name, phone });
  });
}

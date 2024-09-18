package ai.azure.openai.rag.workshop.ingestion.configuration;

import dev.langchain4j.model.embedding.EmbeddingModel;
import dev.langchain4j.model.embedding.onnx.allminilml6v2.AllMiniLmL6V2EmbeddingModel;
import jakarta.enterprise.inject.Produces;

public class EmbeddingModelProducer {

  @Produces
  public EmbeddingModel embeddingModel() {
    return new AllMiniLmL6V2EmbeddingModel();
  }
}

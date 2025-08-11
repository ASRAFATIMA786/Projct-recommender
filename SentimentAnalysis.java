package com.entity;

import java.util.HashMap;
import java.util.Map;

public class SentimentAnalysis {

	
	private Map<String, Integer> positiveWords;
    private Map<String, Integer> negativeWords;

    public SentimentAnalysis() {
        // Initialize positive and negative words with their scores
        positiveWords = new HashMap<>();
        negativeWords = new HashMap<>();

        // Add positive words
        positiveWords.put("good", 3);
        positiveWords.put("happy", 2);
        positiveWords.put("excellent", 5);
        positiveWords.put("super", 4);

        // Add negative words
        negativeWords.put("bad", -3);
        negativeWords.put("sad", -2);
        negativeWords.put("poor", -4);
        negativeWords.put("worst", -5);
    }

    public int analyzeSentiment(String text) {
        String[] words = text.toLowerCase().split("\\s+");
        int sentimentScore = 0;

        // Check each word against positive and negative words
        for (String word : words) {
            if (positiveWords.containsKey(word)) {
                sentimentScore += positiveWords.get(word);
            } else if (negativeWords.containsKey(word)) {
                sentimentScore += negativeWords.get(word);
            }
        }

        return sentimentScore;
    }

	
	/*
	 * public static void main(String[] args) { SentimentAnalysis analyzer = new
	 * SentimentAnalysis();
	 * 
	 * // Example text String text =
	 * "The movie was good and made me happy, but the ending was sad.";
	 * 
	 * //Analyze sentiment int sentimentScore = analyzer.analyzeSentiment(text);
	 * 
	 * // Output sentiment score System.out.println("Sentiment Score: " +
	 * sentimentScore); }
	 */
}



//product sentiment analyzer


/*
 * import edu.stanford.nlp.simple.*;
 * 
 * public class ProductSentimentAnalyzer {
 * 
 * public static void main(String[] args) { // Example product reviews String[]
 * reviews = { "This product is amazing! I love it.",
 * "The quality of the product is poor. Not satisfied.",
 * "Neutral review for the product.", // Add more reviews as needed };
 * 
 * // Analyze sentiment for each review for (String review : reviews) { int
 * sentimentScore = analyzeSentiment(review);
 * System.out.println("Sentiment Score: " + sentimentScore + " for review: " +
 * review); }
 * 
 * // You can aggregate scores and rank products based on the overall sentiment
 * scores. }
 * 
 * private static int analyzeSentiment(String text) { // Use Stanford CoreNLP
 * for sentiment analysis Annotation annotation = new Annotation(text);
 * StanfordCoreNLP pipeline = new StanfordCoreNLP();
 * pipeline.annotate(annotation);
 * 
 * // Get the sentiment score (1 to 5, where 1 is very negative and 5 is very
 * positive) int sentimentScore = 0; for (CoreMap sentence :
 * annotation.get(CoreAnnotations.SentencesAnnotation.class)) { Tree tree =
 * sentence.get(SentimentCoreAnnotations.SentimentAnnotatedTree.class);
 * sentimentScore += RNNCoreAnnotations.getPredictedClass(tree); }
 * 
 * // Normalize the sentiment score (optional) if (sentimentScore > 0) {
 * sentimentScore = (sentimentScore - 1) / 4 + 1; }
 * 
 * return sentimentScore; } }
 * 
 */
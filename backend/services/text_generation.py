import cohere


def use_llm(prompt):
    co = cohere.Client('gmX9QEICDBu2ylcOCe13yu9NPBqgPbndvNBcF7jJ')

    response = co.generate(
        model='command', #or other model.
        prompt=prompt,
        max_tokens=300,
        temperature=0.9,
        k=0,
        stop_sequences=[],
        return_likelihoods='NONE'
    )

    return response.generations[0].text
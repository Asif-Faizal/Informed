import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tdd_clean/features/news/bloc/news_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsBloc, NewsState>(
      listener: (context, state) {
        print('Current state in listener: $state');
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
            child: Column(
              children: [
                _buildSearchSection(context),
                _buildNewsList(state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    final controller = TextEditingController();

    return Column(
      children: [
        TextField(
          style: TextStyle(color: Colors.deepPurpleAccent.shade400,fontSize: 17,fontWeight: FontWeight.w700),
          controller: controller,
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(255, 243, 235, 255),
            filled: true,
            labelText: '    Enter search query',
            labelStyle: TextStyle(color: Colors.deepPurpleAccent.shade400,fontSize: 15,fontWeight: FontWeight.w600),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(width: 3,color: Colors.deepPurpleAccent.shade200)
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(width: 2,color: Colors.deepPurpleAccent.shade200)
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(width: 3,color: Colors.deepPurpleAccent.shade200)
            ),
            suffixIcon: InkWell(
              onTap: () {
                final query = controller.text.trim();
                if (query.isNotEmpty) {
                  print('Dispatching GetCountryWiseNewsEvent with query: $query');
                  context.read<NewsBloc>().add(
                        GetQueryNewsEvent(
                          query: query,
                        ),
                      );
                }
              },
              child: Icon(Icons.search,color: Colors.deepPurpleAccent.shade200,),
            ),
          ),
            onSubmitted: (value) {
              final value = controller.text.trim();
                if (value.isNotEmpty) {
                  print('Dispatching GetCountryWiseNewsEvent with query: $value');
                  context.read<NewsBloc>().add(
                        GetQueryNewsEvent(
                          query: value,
                        ),
                      );
                }
            },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor:  const Color.fromARGB(255, 243, 235, 255),
      highlightColor:Colors.white,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
                    color: Colors.white,),
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            height: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 150,
                            height: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsList(NewsState state) {
    return Expanded(
      child: Builder(
        builder: (context) {
          print('Building news list with state: $state');

          if (state is CountryNewsLoading || state is QueryNewsLoading) {
            return _buildShimmerLoading();
          }

          if (state is CountryNewsLoaded || state is QueryNewsLoaded) {
            final articles = state is CountryNewsLoaded 
                ? state.news 
                : (state as QueryNewsLoaded).news;

            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  color:  const Color.fromARGB(255, 243, 235, 255),
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.urlToImage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.deepPurpleAccent.shade100,width: 1)
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                article.urlToImage!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: Icon(Icons.error_outline),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.source, size: 16, color:Colors.deepPurpleAccent.shade200),
                                const SizedBox(width: 4),
                                Text(
                                  article.sourceName,
                                  style: TextStyle(
                                    color:Colors.deepPurpleAccent.shade200,
                                    fontSize: 14,
                                  ),
                                ),
                                if (article.author != null) ...[
                                  const SizedBox(width: 16),
                                  Icon(Icons.person, size: 16, color:Colors.deepPurpleAccent.shade200,),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      article.author!,
                                      style: TextStyle(
                                        color:Colors.deepPurpleAccent.shade200,
                                        fontSize: 14,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (article.description != null) ...[
                              Text(
                                article.description!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                            ],
                            if (article.content != null) ...[
                              Text(
                                article.content!,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                            ],
                            Text(
                              'Published: ${DateFormat('MMM dd, yyyy HH:mm').format(article.publishedAt)}',
                              style: TextStyle(
                                color: Colors.deepPurpleAccent.shade200,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 3,),
                            InkWell(
                              child:  Text('read more...',style: TextStyle(color: Colors.deepPurpleAccent.shade200,fontSize: 14,fontWeight: FontWeight.bold)),
                              onTap: () async {
                                if (await canLaunchUrl(Uri.parse(article.url))) {
                                  await launchUrl(Uri.parse(article.url));
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          if (state is CountryNewsError) {
            return Center(child: Text(state.errorMessage));
          }

          return const Center(child: Text('Search for news'));
        },
      ),
    );
  }
}
import 'package:alduin/github.dart';
import 'package:flutter/material.dart';
import 'package:alduin/zhihu.dart';
import 'package:alduin/douban_movie.dart';

class Hot extends StatefulWidget {
  const Hot({super.key});

  @override
  State<StatefulWidget> createState() => _HotState();

}

class _HotState extends State<Hot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '最火',
          style: TextStyle(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: const Text('知乎'),
            subtitle: const Text('发现更大世界'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ZhihuHot()),
              );
            },
          ),
          ListTile(
            title: const Text('github'),
            subtitle: const Text('全球最大同性交友平台'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Github()),
              );
            },
          ),
          ListTile(
            title: const Text('豆瓣电影'),
            subtitle: const Text('我们的精神角落。'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DoubanMovie()),
              );
            },
          ),
        ],
      ),
    );
  }

}

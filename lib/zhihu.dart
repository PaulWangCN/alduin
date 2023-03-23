import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:dio/dio.dart';

class ZhihuHot extends StatefulWidget {
  const ZhihuHot({super.key});

  @override
  State<StatefulWidget> createState() => _ZhihuHot();
}

class _ZhihuHot extends State<ZhihuHot> {
  final List<ZhihuHotTitle> _list = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _loading = true;
    var url = "https://www.zhihu.com/billboard";
    Response response = await Dio().get(url);
    dom.Document document = parser.parse(response.data);
    List<dom.Element> elementsByClassName =
        document.getElementsByClassName('HotList-item');
    List<ZhihuHotTitle> list = [];
    for (dom.Element element in elementsByClassName) {
      String title =
          element.getElementsByClassName('HotList-itemTitle')[0].text.trim();
      String subtitle =
          element.getElementsByClassName('HotList-itemMetrics')[0].text.trim();
      ZhihuHotTitle alduinTitle =
          ZhihuHotTitle(title: title, subtitle: subtitle);
      list.add(alduinTitle);
    }
    setState(() {
      _list.clear();
      _list.addAll(list);
    });
    _loading = false;
  }

  Widget _childLayout() {
    if (_loading) {
      return const Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.blue,
          ),
        ),
      );
    } else {
      return Builder(builder: (context) {
        return ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            final int lineNo = index + 1;
            final String title = (_list)[index].title;
            final String subtitle = (_list)[index].subtitle;
            return ListTile(
              title: Text(
                '#$lineNo $title',
                style: const TextStyle(color: Colors.lightBlue),
              ),
              subtitle: Text(
                subtitle,
                style: const TextStyle(color: Colors.red),
              ),
            );
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '知乎最热',
          style: TextStyle(),
        ),
      ),
      body: _childLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: _getData,
        tooltip: '刷新',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class ZhihuHotTitle {
  final String title;
  final String subtitle;

  ZhihuHotTitle({
    required this.title,
    required this.subtitle,
  });
}

import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/cubits/resultsCubit.dart';
import 'package:eschool/data/models/result.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';
import 'package:eschool/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool/ui/widgets/customShimmerContainer.dart';
import 'package:eschool/ui/widgets/errorContainer.dart';
import 'package:eschool/ui/widgets/listItemForExamAndResult.dart';
import 'package:eschool/ui/widgets/noDataContainer.dart';
import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultsContainer extends StatefulWidget {
  final int? childId;

  ResultsContainer({Key? key, this.childId}) : super(key: key);

  @override
  State<ResultsContainer> createState() => _ResultsContainerState();
}

class _ResultsContainerState extends State<ResultsContainer> {
  late ScrollController _scrollController = ScrollController()
    ..addListener(_resultsScrollListener);

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchResults();
    });
    super.initState();
  }

  void fetchResults() {
    context.read<ResultsCubit>().fetchResults(
        useParentApi: context.read<AuthCubit>().isParent(),
        childId: widget.childId);
  }

  void _resultsScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (context.read<ResultsCubit>().hasMore()) {
        context.read<ResultsCubit>().fetchMoreResults(
            useParentApi: context.read<AuthCubit>().isParent(),
            childId: widget.childId);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_resultsScrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAppBar() {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.all(0),
      child: Stack(
        children: [
          context.read<AuthCubit>().isParent()
              ? CustomBackButton(
                  alignmentDirectional: AlignmentDirectional.centerStart,
                )
              : SizedBox(),
          Align(
            alignment: Alignment.center,
            child: Text(
              UiUtils.getTranslatedLabel(context, resultsKey),
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: UiUtils.screenTitleFontSize),
            ),
          ),
        ],
      ),
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
    );
  }

  Widget _buildResultDetailsShimmerLoadingContainer() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.5),
      width: MediaQuery.of(context).size.width * (0.85),
      height: 80.0,
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              width: boxConstraints.maxWidth * (0.7),
            )),
            SizedBox(
              height: boxConstraints.maxHeight * (0.25),
            ),
            ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              width: boxConstraints.maxWidth * (0.5),
            )),
          ],
        );
      }),
    );
  }

  Widget _buildResultDetailsContainer(
      {required Result result,
      required int index,
      required int totalResults,
      required bool hasMoreResults,
      required bool hasMoreResultsInProgress,
      required bool fetchMoreResultsFailure}) {
    if (index == (totalResults - 1)) {
      if (hasMoreResults) {
        if (hasMoreResultsInProgress) {
          return _buildResultDetailsShimmerLoadingContainer();
        }
        if (fetchMoreResultsFailure) {
          return Center(
            child: CupertinoButton(
                child: Text(UiUtils.getTranslatedLabel(context, retryKey)),
                onPressed: () {
                  context.read<ResultsCubit>().fetchMoreResults(
                      useParentApi: context.read<AuthCubit>().isParent(),
                      childId: widget.childId);
                }),
          );
        }
      }
    }

    return ListItemForExamAndResult(
        examStartingDate: result.examDate,
        examName: result.examName,
        resultGrade: result.grade,
        resultPercentage: result.percentage,
        onItemTap: () {
          Navigator.of(context).pushNamed(Routes.result,
              arguments: {"childId": widget.childId, "result": result});
        });
  }

  Widget _buildResults() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomRefreshIndicator(
        onRefreshCallback: () {
          if (context.read<ResultsCubit>().state is ResultsFetchSuccess) {
            fetchResults();
          }
        },
        displacment: UiUtils.getScrollViewTopPadding(
            context: context,
            appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: BlocBuilder<ResultsCubit, ResultsState>(
            builder: (context, state) {
              if (state is ResultsFetchSuccess) {

                return state.results.isNotEmpty ? Column(
                  children:
                      List.generate(state.results.length, (index) => index)
                          .map((index) {
                    return _buildResultDetailsContainer(
                        result: state.results[index],
                        index: index,
                        totalResults: state.results.length,
                        hasMoreResults: context.read<ResultsCubit>().hasMore(),
                        hasMoreResultsInProgress:
                            state.fetchMoreResultsInProgress,
                        fetchMoreResultsFailure: state.moreResultsFetchError);
                  }).toList(),
                ) : Center(child: NoDataContainer(titleKey: noResultPublishedKey));
              }
              if (state is ResultsFetchFailure) {
                return ErrorContainer(
                  errorMessageCode: state.errorMessage,
                  onTapRetry: () {
                    fetchResults();
                  },
                );
              }
              return Column(
                children: List.generate(
                    UiUtils.defaultShimmerLoadingContentCount,
                    (index) => _buildResultDetailsShimmerLoadingContainer()),
              );
            },
          ),
          padding: EdgeInsets.only(
              bottom: UiUtils.getScrollViewBottomPadding(context),
              top: UiUtils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage:
                      UiUtils.appBarSmallerHeightPercentage)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildResults(),
        Align(
          alignment: Alignment.topCenter,
          child: _buildAppBar(),
        ),
      ],
    );
  }
}

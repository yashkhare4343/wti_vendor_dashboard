import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wti_vendor_dashboard/core/model/profile/fetch_profile_response.dart';
import 'package:wti_vendor_dashboard/utility/constants/colors/app_colors.dart';
import 'package:wti_vendor_dashboard/utility/constants/fonts/common_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:wti_vendor_dashboard/core/route_management/app_routes.dart';

import '../../core/controller/profile/fetch_profile_detail_controller.dart';
import '../dashboard/dashboard.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();

    Future<void> logout(BuildContext context) async {
      try {
        if (Platform.isIOS) {

          final prefs = await SharedPreferences.getInstance();
          await prefs.clear(); // Clear all SharedPreferences data
        } else {
          await secureStorage.deleteAll(); // Clear all FlutterSecureStorage data
        }
        // Navigate to login screen
        GoRouter.of(context).go(AppRoutes.loginScreen);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during logout: $error')),
        );
      }
    }

    // Initialize the controller
    final FetchProfileDetailController controller = Get.put(FetchProfileDetailController());

    // Trigger profile fetch on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProfile('', '', 'profile', context);
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgPrimary1,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Profile",
          style: CommonFonts.appBarText,
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => GoRouter.of(context).go(AppRoutes.dashboard),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: UserIconCircle(
              size: 40,
              backgroundColor: Colors.blueAccent,
              iconColor: Colors.white,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                onTap: (){
                  logout(context);
                },
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.black87),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${controller.errorMessage.value}',
                    style: CommonFonts.bodyText4Secondary1.copyWith(color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.fetchProfile('', '', 'profile', context),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final vendor = controller.profileDetailResponse.value?.vendor;
          if (vendor == null) {
            return Center(child: Text('No profile data available', style: CommonFonts.bodyText4Secondary1));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vendor Name and Email
                Text('Profile Details', style: CommonFonts.h1Purple),
                SizedBox(height: 8),
                Text('Name: ${vendor.vendorName}', style: CommonFonts.bodyText4Secondary1),
                Text('Email: ${vendor.email}', style: CommonFonts.bodyText4Secondary1),
                SizedBox(height: 16),

                // Personal Information
                _buildSectionTitle('Personal Information'),
                _buildInfoCard([
                  _buildInfoRow('Mobile', vendor.mobile),
                  _buildInfoRow('Gender', vendor.gender),
                  _buildInfoRow('Date of Birth', vendor.doB),
                  _buildInfoRow('Base City', vendor.baseCity),
                  _buildInfoRow('Address', vendor.address),
                ]),

                // Vendor Information
                _buildSectionTitle('Vendor Information'),
                _buildInfoCard([
                  _buildInfoRow('Partner Type', vendor.partnerType),
                  _buildInfoRow('Vehicle Number', vendor.vehicleNumber),
                  _buildInfoRow('PAN Card', vendor.panCard),
                  _buildInfoRow('Billing Cycle', '${vendor.billingCycle} days'),
                  _buildInfoRow('Commission', '${vendor.commissionPercentage}%'),
                ]),

                // Bank Details
                _buildSectionTitle('Bank Details'),
                _buildInfoCard([
                  _buildInfoRow('Bank Name', vendor.bankName),
                  _buildInfoRow('IFSC Code', vendor.ifscCode),
                  _buildInfoRow('Account Number', vendor.accountNumber),
                  _buildInfoRow('Account Holder', vendor.accountHolderName),
                  _buildInfoRow('Bank Proof Type', vendor.bankProofType),
                ]),

                // Documents
                _buildSectionTitle('Documents'),
                _buildImageSection('Photograph', vendor.photograph),
                _buildImageSection('Vehicle Registration Certificate', vendor.vehicleRegisterCertificateLink),
                _buildImageSection('PAN Card', vendor.pancardLink),
                _buildImageSection('Address Proof (Front)', vendor.addressProofFrontPhoto),
                _buildImageSection('Address Proof (Back)', vendor.addressProofBackPhoto),
                _buildImageSection('Bank Proof Document', vendor.bankProofDocumentLink),

                // Last Updated

              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: CommonFonts.h1Purple.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: CommonFonts.bodyText4Secondary1.copyWith(fontWeight: FontWeight.w600)),
          Flexible(child: Text(value, style: CommonFonts.bodyText4Secondary1, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildImageSection(String title, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Center(
                child: Text('Failed to load image', style: CommonFonts.bodyText4Secondary1.copyWith(color: Colors.red)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
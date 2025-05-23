import SwiftUI

struct RecruitmentView: View {
    @State private var searchText = ""
    @State private var selectedJobType = 0
    @State private var selectedSalaryRange = 0
    @State private var selectedExperience = 0
    @State private var selectedRegion = 0
    @State private var isAnimated = false
    
    // 职位类型
    let jobTypes = ["全部", "司机", "仓管", "调度", "客服", "管理"]
    
    // 薪资范围
    let salaryRanges = ["不限", "3-5K", "5-8K", "8-12K", "12-20K", "20K+"]
    
    // 经验要求
    let experienceOptions = ["不限", "无经验", "1-3年", "3-5年", "5-10年", "10年+"]
    
    // 地区选项
    let regions = ["不限", "北京", "上海", "广州", "深圳", "杭州", "成都", "武汉"]
    
    // 示例职位数据
    let jobListings = [
        JobListing(
            id: 1,
            title: "货车司机",
            company: "顺丰速运",
            salary: "8000-12000",
            location: "上海市",
            experience: "3-5年",
            jobType: "司机",
            description: "负责货物运输，熟悉华东地区路线",
            requirements: ["持有A2驾照", "3年以上驾驶经验", "熟悉货运法规"],
            benefits: ["五险一金", "包食宿", "年终奖"],
            isUrgent: true
        ),
        JobListing(
            id: 2,
            title: "仓库管理员",
            company: "京东物流",
            salary: "6000-8000",
            location: "北京市",
            experience: "1-3年",
            jobType: "仓管",
            description: "负责仓库日常管理、货物出入库",
            requirements: ["高中以上学历", "仓储管理经验", "熟练使用办公软件"],
            benefits: ["五险一金", "带薪年假", "节日福利"],
            isUrgent: false
        ),
        JobListing(
            id: 3,
            title: "运输调度员",
            company: "中通快递",
            salary: "7000-10000",
            location: "广州市",
            experience: "3-5年",
            jobType: "调度",
            description: "负责车辆调度、路线规划、运输协调",
            requirements: ["本科学历", "物流相关专业", "良好沟通能力"],
            benefits: ["五险一金", "绩效奖金", "培训机会"],
            isUrgent: true
        ),
        JobListing(
            id: 4,
            title: "客服专员",
            company: "德邦物流",
            salary: "5000-7000",
            location: "深圳市",
            experience: "1-3年",
            jobType: "客服",
            description: "处理客户咨询、投诉，维护客户关系",
            requirements: ["大专以上学历", "良好的沟通能力", "客服经验优先"],
            benefits: ["五险一金", "双休", "绩效奖金"],
            isUrgent: false
        )
    ]
    
    var filteredJobs: [JobListing] {
        var filtered = jobListings
        
        // 按职位类型筛选
        if selectedJobType > 0 {
            let targetType = jobTypes[selectedJobType]
            filtered = filtered.filter { $0.jobType == targetType }
        }
        
        // 按搜索文本筛选
        if !searchText.isEmpty {
            filtered = filtered.filter { 
                $0.title.contains(searchText) || 
                $0.company.contains(searchText) ||
                $0.location.contains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 搜索栏和快速操作
                VStack(spacing: 12) {
                    // 搜索栏
                    HStack(spacing: 12) {
                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16))
                                .foregroundColor(Color(red: 102/255, green: 187/255, blue: 106/255))
                            
                            TextField("搜索职位、公司或地区", text: $searchText)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.15), Color(red: 165/255, green: 214/255, blue: 167/255).opacity(0.08)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                    }
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : -10)
                    
                    // 快速操作按钮
                    HStack(spacing: 12) {
                        // 发布招聘按钮
                        NavigationLink(destination: PostJobView()) {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 16))
                                Text("发布招聘")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 76/255, green: 175/255, blue: 80/255), Color(red: 56/255, green: 142/255, blue: 60/255)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(20)
                        }
                        
                        // 我要求职按钮
                        NavigationLink(destination: JobApplicationView()) {
                            HStack(spacing: 6) {
                                Image(systemName: "person.crop.circle.fill.badge.plus")
                                    .font(.system(size: 16))
                                Text("我要求职")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(.black)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.2), Color(red: 165/255, green: 214/255, blue: 167/255).opacity(0.1)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(20)
                        }
                        
                        Spacer()
                    }
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : -10)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // 筛选标签
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        // 职位类型筛选
                        ForEach(0..<jobTypes.count, id: \.self) { index in
                            FilterTag(
                                title: jobTypes[index],
                                isSelected: selectedJobType == index,
                                action: { selectedJobType = index }
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 8)
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : -10)
                
                // 职位列表
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(filteredJobs.enumerated()), id: \.element.id) { index, job in
                            NavigationLink(destination: JobDetailsView(job: job)) {
                                JobCard(job: job, index: index, isAnimated: isAnimated)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .opacity(isAnimated ? 1 : 0)
                .offset(y: isAnimated ? 0 : 10)
            }
            .navigationTitle("招聘求职")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                withAnimation(DesignSystem.Animation.spring) {
                    isAnimated = true
                }
            }
        }
    }
}

// 职位数据模型
struct JobListing {
    let id: Int
    let title: String
    let company: String
    let salary: String
    let location: String
    let experience: String
    let jobType: String
    let description: String
    let requirements: [String]
    let benefits: [String]
    let isUrgent: Bool
}

// 筛选标签组件
struct FilterTag: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)

                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? 
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 76/255, green: 175/255, blue: 80/255), Color(red: 56/255, green: 142/255, blue: 60/255)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.2), Color(red: 165/255, green: 214/255, blue: 167/255).opacity(0.1)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// 职位卡片组件
struct JobCard: View {
    let job: JobListing
    let index: Int
    let isAnimated: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 职位标题和紧急标识
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(job.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(DesignSystem.Colors.Label.primary)
                    
                    Text(job.company)
                        .font(.system(size: 14))
                        .foregroundColor(DesignSystem.Colors.Label.secondary)
                }
                
                Spacer()
                
                if job.isUrgent {
                    Text("急聘")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 255/255, green: 59/255, blue: 48/255))
                        .cornerRadius(8)
                }
            }
            
            // 薪资信息
            Text(job.salary)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
            
            // 职位详情
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 102/255, green: 187/255, blue: 106/255))
                    Text(job.location)
                        .font(.system(size: 12))
                        .foregroundColor(DesignSystem.Colors.Label.secondary)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 102/255, green: 187/255, blue: 106/255))
                    Text(job.experience)
                        .font(.system(size: 12))
                        .foregroundColor(DesignSystem.Colors.Label.secondary)
                }
                
                Spacer()
            }
            
            // 职位描述
            Text(job.description)
                .font(.system(size: 14))
                .foregroundColor(DesignSystem.Colors.Label.secondary)
                .lineLimit(2)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
        )
        .opacity(isAnimated ? 1 : 0)
        .offset(y: isAnimated ? 0 : 20)
        .animation(DesignSystem.Animation.spring.delay(0.05 * Double(index)), value: isAnimated)
    }
}

// 职位详情页面
struct JobDetailsView: View {
    let job: JobListing
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 职位标题和公司
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(job.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(DesignSystem.Colors.Label.primary)
                        
                        Spacer()
                        
                        if job.isUrgent {
                            Text("急聘")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(red: 255/255, green: 59/255, blue: 48/255))
                                .cornerRadius(12)
                        }
                    }
                    
                    Text(job.company)
                        .font(.system(size: 18))
                        .foregroundColor(DesignSystem.Colors.Label.secondary)
                }
                .padding(.horizontal, 20)
                
                // 薪资信息
                VStack(alignment: .leading, spacing: 12) {
                    Text("薪资待遇")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.Label.primary)
                    
                    Text(job.salary)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                }
                .padding(.horizontal, 20)
                
                // 基本信息
                VStack(alignment: .leading, spacing: 12) {
                    Text("基本信息")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.Label.primary)
                    
                    HStack(spacing: 20) {
                        HStack(spacing: 6) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 102/255, green: 187/255, blue: 106/255))
                            Text(job.location)
                                .font(.system(size: 14))
                                .foregroundColor(DesignSystem.Colors.Label.secondary)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 14))
                                .foregroundColor(Color(red: 102/255, green: 187/255, blue: 106/255))
                            Text(job.experience)
                                .font(.system(size: 14))
                                .foregroundColor(DesignSystem.Colors.Label.secondary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // 职位描述
                VStack(alignment: .leading, spacing: 12) {
                    Text("职位描述")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.Label.primary)
                    
                    Text(job.description)
                        .font(.system(size: 16))
                        .foregroundColor(DesignSystem.Colors.Label.secondary)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 20)
                
                // 任职要求
                VStack(alignment: .leading, spacing: 12) {
                    Text("任职要求")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.Label.primary)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(job.requirements, id: \.self) { requirement in
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                                Text(requirement)
                                    .font(.system(size: 16))
                                    .foregroundColor(DesignSystem.Colors.Label.secondary)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // 福利待遇
                VStack(alignment: .leading, spacing: 12) {
                    Text("福利待遇")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(DesignSystem.Colors.Label.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(job.benefits, id: \.self) { benefit in
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color(red: 76/255, green: 175/255, blue: 80/255))
                                    .font(.system(size: 14))
                                Text(benefit)
                                    .font(.system(size: 14))
                                    .foregroundColor(DesignSystem.Colors.Label.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 129/255, green: 199/255, blue: 132/255).opacity(0.15), Color(red: 165/255, green: 214/255, blue: 167/255).opacity(0.08)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // 投递按钮
                Button(action: {
                    // 投递简历功能
                }) {
                    Text("立即投递")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 76/255, green: 175/255, blue: 80/255), Color(red: 56/255, green: 142/255, blue: 60/255)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .navigationTitle("职位详情")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 发布招聘页面
struct PostJobView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("发布招聘信息")
                    .font(.system(size: 18))
                    .foregroundColor(DesignSystem.Colors.Label.secondary)
                    .padding(.horizontal, 20)
                
                // 这里可以添加发布招聘的表单
                VStack(spacing: 16) {
                    Text("发布招聘功能开发中...")
                        .font(.system(size: 16))
                        .foregroundColor(DesignSystem.Colors.Label.tertiary)
                        .padding()
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationTitle("发布招聘")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 求职申请页面
struct JobApplicationView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("投递简历和求职申请")
                    .font(.system(size: 18))
                    .foregroundColor(DesignSystem.Colors.Label.secondary)
                    .padding(.horizontal, 20)
                
                // 这里可以添加求职申请的表单
                VStack(spacing: 16) {
                    Text("求职申请功能开发中...")
                        .font(.system(size: 16))
                        .foregroundColor(DesignSystem.Colors.Label.tertiary)
                        .padding()
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .navigationTitle("我要求职")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    RecruitmentView()
} 

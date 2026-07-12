\*\*✅ Hướng dẫn bắt đầu một Feature mới trong AI-Kit\*\*



Dưới đây là quy trình \*\*chuẩn\*\* theo AGENTS.md và Planner agent.



\### Bước 1: Tạo thư mục Feature



```bash

mkdir -p features/ten-feature-cua-ban

```



Ví dụ: `features/user-auth`, `features/payment-integration`, `features/dashboard-ui`



\### Bước 2: Tạo file `brief.md` (Quan trọng nhất)



Tạo file: `features/ten-feature/brief.md`



\*\*Nội dung gợi ý\*\* (theo template):



```markdown

\# Feature: Tên feature



\## Goal (mục tiêu một câu)

...



\## Requirements

\- Yêu cầu chức năng chính

\- User flow

\- Edge cases quan trọng



\## Constraints / Non-functional

\- Performance

\- Security

\- Tech stack phải tuân thủ

\- Integration points



\## Out of scope (rất quan trọng)

\- Những gì không làm trong feature này

```



\### Bước 3: (Tùy chọn) Thêm research/context



```bash

mkdir -p features/ten-feature/research

mkdir -p features/ten-feature/context

```



\- `research/requirements.md` → ghi nghiên cứu, API docs, quyết định

\- `context/` → ghi API notes, database schema liên quan, v.v.



\### Bước 4: Chạy lệnh Plan (Gate G1)



Bạn (hoặc AI) chạy lệnh:



\*\*Cách dùng phổ biến:\*\*



\- Với \*\*Claude Code\*\*: `/plan ten-feature`

\- Với \*\*Windsurf\*\*: dùng workflow `plan`

\- Với các tool khác: paste nội dung của `.ai/commands/plan.md` và chỉ định feature name.



\*\*Planner agent sẽ tự động\*\*:

1\. Đọc `brief.md`

2\. Phân tích intent + size (trivial / standard / large)

3\. Tạo:

&#x20;  - `.project/ten-feature/plan.md`

&#x20;  - `.project/ten-feature/tasks.md` (có acceptance criteria)

4\. Cập nhật `.project/INDEX.md`



\### Bước 5: Bắt đầu Implement



Sau khi có `tasks.md`, bạn có thể chạy:



\- `/implement ten-feature` → AI sẽ tự pick task tiếp theo (T1, T2...) theo thứ tự và dependency.

\- Hoặc chỉ định task: `/implement ten-feature T3`



\---



\### Quy trình tổng quát sau khi Plan



```

1\. Plan (G1) 

&#x20;  ↓

2\. Architect (nếu feature lớn)

&#x20;  ↓

3\. Implement tasks (Backend/Frontend/Database...) 

&#x20;  ↓

4\. QA + Review (G3)

&#x20;  ↓

5\. Documenter + Release

```



\---



\*\*Mẹo thực tế:\*\*



1\. \*\*Brief càng rõ\*\* → Planner càng tốt → ít phải hỏi lại.

2\. Feature đầu tiên nên nhỏ để test quy trình.

3\. Sau khi plan xong, bạn nên \*\*review\*\* file `tasks.md` trước khi cho AI implement.

4\. Muốn reset plan: xóa thư mục `.project/ten-feature/` rồi chạy plan lại (features/ vẫn giữ nguyên).



\---



Bạn muốn mình:

\- Tạo giúp một `brief.md` mẫu cho feature cụ thể nào không?

\- Hay hướng dẫn chi tiết cách chạy lệnh trong tool bạn đang dùng (Claude, Cursor, Windsurf...)? 



Cứ nói feature bạn muốn làm là gì, mình hỗ trợ tạo brief + plan luôn! 🚀

